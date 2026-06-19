# 차이나 데일리 브리프 — GitHub Pages 배포 스크립트
# Claude가 index.html / editions/<date>.html / archive.html 을 갱신한 뒤 호출.
# 사용법:  powershell -File publish.ps1            (오늘 날짜 커밋)
#          powershell -File publish.ps1 2026-06-19
# 인증: C:\Users\user\gh-token.txt 의 PAT(repo 스코프)로 푸시.

param([string]$Date = (Get-Date -Format "yyyy-MM-dd"))
$ErrorActionPreference = "Stop"
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

$site = "C:\Users\user\china-daily-brief-site"
$tokFile = "C:\Users\user\gh-token.txt"
if (-not (Test-Path $tokFile)) { Write-Error "토큰 파일 없음: $tokFile (PAT 재발급 후 저장 필요)"; exit 1 }
$tok = (Get-Content $tokFile -Raw).Trim()

Set-Location $site
git add -A
$pending = git status --porcelain
if (-not $pending) { Write-Host "변경 사항 없음 — 배포 생략"; exit 0 }
git commit -m "차이나 데일리 브리프 $Date" | Out-Host
git push "https://KIM7022:$tok@github.com/KIM7022/china-daily-brief.git" main 2>&1 | Out-Host
Write-Host "`n배포 완료 → https://kim7022.github.io/china-daily-brief/  (반영까지 1~2분)"
