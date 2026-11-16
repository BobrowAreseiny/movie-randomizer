$ErrorActionPreference = 'Stop'
$env:GIT_TERMINAL_PROMPT = '0'
$payload = "protocol=https`nhost=github.com`n`n"
$cred = $payload | git credential fill 2>$null
$token = ($cred | Where-Object { $_ -like 'password=*' }) -replace '^password=',''
$headers = @{
    Authorization = "Bearer $token"
    Accept = 'application/vnd.github+json'
    'User-Agent' = 'OpenCode'
}
$owner = 'BobrowAreseiny'
$repo = 'movie-randomizer'
$description = 'Local-first film library and randomizer. Letterboxd metadata import, filters, list and poster-grid views, and a no-repeat picker.'

$repoExists = $false
try {
    $null = Invoke-RestMethod -Uri "https://api.github.com/repos/$owner/$repo" -Headers $headers
    $repoExists = $true
} catch {
    if ($_.Exception.Response.StatusCode.value__ -ne 404) { throw }
}

if (-not $repoExists) {
    $body = @{
        name = $repo
        description = $description
        private = $false
        has_issues = $false
        has_wiki = $false
        has_projects = $false
        auto_init = $false
    } | ConvertTo-Json
    $created = Invoke-RestMethod -Method Post -Uri 'https://api.github.com/user/repos' -Headers $headers -Body $body -ContentType 'application/json'
    Write-Output ("repo_created=" + $created.html_url)
} else {
    Write-Output "repo_exists=true"
}

if (-not (Test-Path '.git')) {
    git init -b main | Out-Null
}
git config user.name 'Arseniy Bobrov'
git config user.email '90495632+BobrowAreseiny@users.noreply.github.com'
git add .
git commit -m 'Initial commit: Movie Randomizer' | Out-Null
git remote remove origin 2>$null
git remote add origin "https://github.com/$owner/$repo.git"
git push -u origin main

$pagesBody = @{ source = @{ branch = 'main'; path = '/' } } | ConvertTo-Json
try {
    $pages = Invoke-RestMethod -Method Post -Uri "https://api.github.com/repos/$owner/$repo/pages" -Headers $headers -Body $pagesBody -ContentType 'application/json'
    Write-Output ("pages_created=" + $pages.html_url)
} catch {
    if ($_.Exception.Response.StatusCode.value__ -eq 409) {
        $pages = Invoke-RestMethod -Method Put -Uri "https://api.github.com/repos/$owner/$repo/pages" -Headers $headers -Body $pagesBody -ContentType 'application/json'
        Write-Output ("pages_updated=" + $pages.html_url)
    } else {
        throw
    }
}
$state = Invoke-RestMethod -Uri "https://api.github.com/repos/$owner/$repo/pages" -Headers $headers
Write-Output ("pages_status=" + $state.status)
Write-Output ("pages_url=" + $state.html_url)
