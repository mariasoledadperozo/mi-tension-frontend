# ============================================================
#  push_all_branches.ps1
#  Vincula la carpeta local al repo de GitHub y hace push
#  del codigo actual a master, develop y todas las ramas feature/*
#
#  USO:
#    1. Coloca este script en la carpeta raiz del proyecto
#       (donde esta la carpeta mi_tension/)
#    2. Abre PowerShell como administrador en esa carpeta
#    3. Ejecuta:  .\push_all_branches.ps1
# ============================================================

param(
    [string]$RepoUrl   = "https://github.com/mariasoledadperozo/mi-tension-frontend.git",
    [string]$CommitMsg = "chore: sync local code to all branches"
)

# ---------- helpers ----------
function Write-Step($msg) { Write-Host "`n==> $msg" -ForegroundColor Cyan }
function Write-OK($msg)   { Write-Host "    OK: $msg"    -ForegroundColor Green }
function Write-Warn($msg) { Write-Host "    WARN: $msg"  -ForegroundColor Yellow }
function Invoke-Git {
    git @args
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERROR: git $args fallo (codigo $LASTEXITCODE)" -ForegroundColor Red
        exit 1
    }
}

# ---------- verificar que git esta instalado ----------
Write-Step "Verificando Git..."
try { git --version | Out-Null } catch {
    Write-Host "Git no encontrado. Instalalo desde https://git-scm.com" -ForegroundColor Red
    exit 1
}
Write-OK "Git disponible"

# ---------- directorio de trabajo ----------
$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $projectRoot
Write-OK "Directorio: $projectRoot"

# ---------- inicializar repo local si no existe ----------
Write-Step "Comprobando repositorio local..."
if (-not (Test-Path ".git")) {
    Write-Warn ".git no encontrado. Inicializando repo..."
    Invoke-Git init
    Invoke-Git checkout -b master
} else {
    Write-OK ".git ya existe"
}

# ---------- configurar remote origin ----------
Write-Step "Configurando remote origin..."
$remotes = git remote
if ($remotes -contains "origin") {
    $currentUrl = git remote get-url origin
    if ($currentUrl -ne $RepoUrl) {
        Write-Warn "Remote apunta a '$currentUrl'. Actualizando..."
        Invoke-Git remote set-url origin $RepoUrl
    } else {
        Write-OK "Remote origin ya apunta al repo correcto"
    }
} else {
    Invoke-Git remote add origin $RepoUrl
    Write-OK "Remote origin agregado"
}

# ---------- stage + commit ----------
Write-Step "Preparando commit con todos los cambios..."
Invoke-Git add -A

$status = git status --porcelain
if ([string]::IsNullOrWhiteSpace($status)) {
    Write-Warn "No hay cambios nuevos. Se hara push del commit actual a todas las ramas."
} else {
    Invoke-Git commit -m $CommitMsg
    Write-OK "Commit creado"
}

# ---------- ramas a actualizar ----------
$mainBranches    = @("master", "develop")
$featureBranches = @(
    "feature/flutter-navigation",
    "feature/flutter-recordatorios",
    "feature/flutter-graficas",
    "feature/flutter-historial",
    "feature/flutter-popup-analisis",
    "feature/flutter-form-pression",
    "feature/flutter-auth"
)
$allBranches = $mainBranches + $featureBranches

# Guardar SHA del commit actual
$commitSHA = git rev-parse HEAD

# ---------- push a cada rama ----------
Write-Step "Haciendo push a todas las ramas..."

foreach ($branch in $allBranches) {
    Write-Host "`n  -> $branch" -ForegroundColor White

    # Crear la rama local si no existe, apuntando al commit actual
    $localBranches = git branch --list $branch
    if ([string]::IsNullOrWhiteSpace($localBranches)) {
        git branch $branch $commitSHA 2>$null
    }

    # Force push al remote (sobreescribe la rama remota con el codigo local)
    Invoke-Git push origin "${commitSHA}:refs/heads/${branch}" --force
    Write-OK "Push completado -> $branch"
}

# ---------- volver a master ----------
Write-Step "Volviendo a master..."
$currentBranch = git rev-parse --abbrev-ref HEAD
if ($currentBranch -ne "master") {
    Invoke-Git checkout master
}

Write-Host "`n============================================" -ForegroundColor Green
Write-Host "  LISTO. Codigo subido a todas las ramas:  " -ForegroundColor Green
$allBranches | ForEach-Object { Write-Host "    - $_" -ForegroundColor Green }
Write-Host "  Repo: $RepoUrl"                             -ForegroundColor Green
Write-Host "============================================`n" -ForegroundColor Green
