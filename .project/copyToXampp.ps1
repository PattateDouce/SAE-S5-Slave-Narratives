# Check if memory.json exists
$jsonFilePath = Join-Path -Path $PSScriptRoot -ChildPath "memory.json"
if (-not (Test-Path -Path $jsonFilePath -PathType Leaf)) {
    Write-Host "The 'memory.json' file does not exist. Please create 'memory.json' based on 'memory.example.json' and fill in your values."
    exit 1
}

# Read the existing memory.json file
$jsonContent = Get-Content -Path $jsonFilePath | ConvertFrom-Json

# Define folder paths
$gitFolder = $jsonContent.GIT_FOLDER
$xamppFolder = $jsonContent.XAMPP_FOLDER
$folderToCopy = $jsonContent.FOLDER_TO_COPY

# Create an array of paths to check
$pathsToCheck = @($gitFolder, $xamppFolder)

# Check if all specified folders exist
if ($pathsToCheck | ForEach-Object { Test-Path -Path $_ -PathType Container }) {
    # Remove the old slave_narratives folder in the XAMPP_FOLDER if it exists
    $oldSlaveNarrativesPath = Join-Path -Path $xamppFolder -ChildPath $folderToCopy
    if (Test-Path -Path $oldSlaveNarrativesPath -PathType Container) {
        Remove-Item -Path $oldSlaveNarrativesPath -Recurse -Force
    }

    # Copy the slave_narratives folder from GIT_FOLDER to XAMPP_FOLDER
    $newSlaveNarrativesPath = Join-Path -Path $xamppFolder -ChildPath $folderToCopy
    Copy-Item -Path $gitFolder\$folderToCopy -Destination $newSlaveNarrativesPath -Recurse

    Write-Host "The slave_narratives folder has been replaced in the XAMPP_FOLDER."
} else {
    Write-Host "One or both of the specified folders do not exist."
}
