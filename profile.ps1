$PSStyle.FileInfo.Directory = "`e[34m"

Set-Alias -Name lg -Value lazygit

Invoke-Expression (&starship init powershell)

Import-Module git-aliases -DisableNameChecking
Import-Module ZLocation;
Import-Module posh-git

Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
# Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

function cc() {

    $cc_default = "X:\c3d\cc.bat"
    $cc = Join-Path $PWD.Path "cc.bat"

    if (-not (Test-Path $cc))
    {
        $cc = $cc_default
    }

    & $cc $args
}

function .. {
    Set-Location ..
}
function ... {
    Set-Location ..\..
}

function _g {
    try {
        $selectedLocation = (Get-ZLocation).GetEnumerator() |
        Sort-Object -Property Value -Descending |
        ForEach-Object { $_.Key } |
        Invoke-Fzf -NoSort

        return $selectedLocation
    }
    catch {
        # Handle exceptions if necessary
        Write-Error "An error occurred: $_"
        return $null
    }
}

Remove-Alias -Name z
function z() {
    if ($args) {
        Invoke-ZLocation $args
    }
    else {
        $result = _g
        if ($result) {
            Set-Location $result
        }
    }
}

function c() {
    if ($args) {
        $top=(Get-ZLocation $args).GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 1
        if ($top) {
            $result = $top.Name
        } else {
            $result = $args
        }
    }
    else {
        $result = _g
    }

    if ($result) {
        Write-Host opening $result with code...
        code "$result"
    }
}

function gco() {
    if (-not (IsInGitRepo)) {
        Write-Error 'git repo could not be found'
        return
    }

    if ($args) {
        git checkout $args
    }
    else {
        $branch = Invoke-PsFzfGitBranches
        git checkout $branch
    }
}

function gcob() {
    if (-not (IsInGitRepo)) {
        Write-Error 'git repo could not be found'
        return
    }

    if ($args) {
        git checkout --no-track -B $args
    }
}

# reset current branch
function gre() {
    if (-not (IsInGitRepo)) {
        Write-Error 'git repo could not be found'
        return
    }

    $branch = Get-Git-CurrentBranch
    if ($branch) {
        $base_branch = $args
        if (!$args) {
            $base_branch = Invoke-PsFzfGitBranches
        }
        git checkout --no-track -B $branch $base_branch
    }

}

function Get-GitFzfArguments() {
    # take from https://github.com/junegunn/fzf-git.sh/blob/f72ebd823152fa1e9b000b96b71dd28717bc0293/fzf-git.sh#L89
    return @{
        Ansi          = $true
        Layout        = 'reverse'
        Multi         = $true
        Height        = '50%'
        MinHeight     = 20
        Border        = $true
        Color         = 'header:italic:underline'
        PreviewWindow = 'right,50%,border-left'
        Bind          = @('ctrl-/:change-preview-window(down,50%,border-top|hidden|)')
    }
}

# $previewCmd = 'git show --color=always {1}'
# $previewCmd = 'git log -n 25 --oneline --graph --date=short --color=always {1}'

function IsInGitRepo() {
    git rev-parse HEAD 2>&1 | Out-Null
    return $?
}

function Get-Branches {
    $all = git branch --sort=committerdate --sort=HEAD --format='%(HEAD) %(color:yellow)%(refname:short) %(color:green)(%(committerdate:relative))\t%(color:blue)%(subject)%(color:reset)' --color=always |
    % {
        $crap = $_.Split('\t');
        [PSCustomObject]@{
            branch = $crap[0]
            info   = $crap[1]
        }
    }
    $PSStyle.OutputRendering = 'ANSI'
    $all | format-table -HideTableHeaders | Out-String
}

function fco {
    if (-not (IsInGitRepo)) {
        Write-Error 'git repo could not be found'
        return
    }

    if ($args) {
        git checkout $args
    }
    else {
        $fzfArguments = Get-GitFzfArguments
        $shortcutBranchesAll = 'ctrl-a:change-prompt(🌳 All branches > )+reload(git branch --color=always --all)'
        $shortcutBranchesLocal = 'ctrl-l:change-prompt(🌳 Local branches > )+reload(git branch --color=always)'
        $header = 'CTRL-A (all branches), CTRL-L (local branches)'
        $fzfArguments['Bind'] += $shortcutBranchesAll
        $fzfArguments['Bind'] += $shortcutBranchesLocal

        $branchCmd = 'git branch --color=always --all'
        $selectedBranch = Invoke-Expression "& $branchCmd" |
        Invoke-Fzf @fzfArguments -Header $header -Prompt '🌲 Branches> ' -Tiebreak begin -ReverseInput |
        ForEach-Object { $_.Trim() -replace '^remotes/\w+/', '' -replace '\* ', '' }

        if ($selectedBranch) {
            $fcoCmd = "git checkout $selectedBranch"
            Write-Host $fcoCmd
            Invoke-Expression "& $fcoCmd"
        }
    }
}

function gss {
    git submodule status
}

function gsur {
    git submodule update --init --recursive
}
function grr {
    $branch = Get-Git-CurrentBranch
    if ($branch) {
        git reset --hard origin/$branch
    }
}

function gd {
    git diff --submodule=diff $args
}

function gdt {
    git difftool --submodule=diff --no-prompt $args
}

function gdc {
    git diff --cached $args
}

function gdct {
    git difftool --submodule=diff --no-prompt --cached $args
}

function gfm {
    git fetch origin master:master
}

function gp {
    $branch = Get-Git-CurrentBranch
    if ($branch) {
        git push -u origin $branch
    }
}

function gpf {
    $branch = Get-Git-CurrentBranch
    if ($branch) {
        git push origin +$branch
    }
}

function rmsb {
    param(
        [string]$sb
    )

    if (-not $sb) {
        Write-Error 'error: please input the submodule path'
    }
    else {
        # Remove the submodule section from .gitmodules file
        git config -f .gitmodules --remove-section "submodule.$sb"

        # Remove the submodule directory working tree and index
        git rm $sb

        # Remove the submodule directory located at .git/modules/$sb
        Remove-Item -Path ".git/modules/$sb" -Force -Recurse
    }
}

function hb {
    hub browse $args
}

Set-Alias -Name gcn -Value gcn!
Set-Alias -Name gp! -Value gpsup


# ------  python -------

function pbuild {
    python setup.py sdist bdist_wheel --universal
}


function pupload {
    python setup.py upload
}
