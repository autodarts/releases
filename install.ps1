$req_version=$Args[0]
$req_version=$req_version -replace "v", ""

if ($req_version -eq "") {
    $version = $(curl -sL https://api.github.com/repos/autodarts/releases/releases/latest | grep tag_name | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+')
    echo "Installing latest version v$version."
} else {
    $version=$(curl -sL https://api.github.com/repos/autodarts/releases/releases | grep tag_name | grep $req_version | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+\(-\(beta\|rc\)[0-9]\+\)\?')
    if ($version -eq "") {
        echo "Requested version v$req_version not found." && exit 1
    }
    echo "Installing requested version v$version."
}

echo "Downloading autodarts${version}.windows-amd64.zip"
$url = "https://github.com/autodarts/releases/releases/download/v${version}/autodarts${version}.windows-amd64.zip"

$tmp = New-TemporaryFile
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -OutFile $tmp $url
$ProgressPreference = 'Continue'
$tmp | Expand-Archive -DestinationPath $env:USERPROFILE/.local/bin -Force

$env:PATH += ";$env:USERPROFILE/.local/bin"

echo "To run it, use the following comamnd:"
echo "    $env:USERPROFILE\.local\bin\autodarts.exe"