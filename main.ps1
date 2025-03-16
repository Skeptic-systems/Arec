<#Skript by Skeptic Systems#>
#Funktion zum definieren von "Win32" u.a für IsKeyDown
Add-Type @'
using System;
using System.Runtime.InteropServices;
 
 
public struct Win32
{
	[DllImport("user32.dll")]
	public static extern int GetAsyncKeyState(int KeyStates);
 
	[DllImport("user32.dll")]
	public static extern void mouse_event(int dwFlags, int dx, int dy, int dwData, int dwExtraInfo);
 
}
'@
Function IsKeyDown($key) {
    return [Convert]::ToBoolean([Win32]::GetAsyncKeyState($key) -band 0x8000)
}

do{#do Für falsche Eingabe Schleift zum Ende des Switches 
#Erster Switch 
clear-host
write-host @"
    ___                  
   /   |  ________  _____
  / /| | / ___/ _ \/ ___/
 / ___ |/ /  /  __/ /__  
/_/  |_/_/   \___/\___/  
"@-ForegroundColor cyan
write-host "Bitte 1 druecken um mit Pfeiltasten zu navigieren" -ForegroundColor Magenta
write-host "Bitte 2 druecken um mit Presets oder zahlen zu navigieren" -ForegroundColor Blue 
write-host "(Experimentell) Bitte 3 druecken um Rainbow Six Siege neuzustarten" -ForegroundColor Cyan  
Write-Host "Bitte 4 druecken um das Skript neu zu laden"-ForegroundColor Green
write-host "Bitte 5 druecken um das Skript zu schließen"-ForegroundColor Red
write-host "> " -NoNewline -ForegroundColor cyan

$Main_input = read-host 

switch ($Main_input)
{




    1 {
clear-host
write-host @"
    ___                  
   /   |  ________  _____
  / /| | / ___/ _ \/ ___/
 / ___ |/ /  /  __/ /__  
/_/  |_/_/   \___/\___/   
"@-ForegroundColor cyan
write-host "Skript wird gestartet" -ForegroundColor Green
Write-Host "Skript aktiv mit Pfeiltasten Rueckstoß anpassen" -ForegroundColor Green
write-host "F10 drucken um das Skript zu beenden" -ForegroundColor Cyan
write-host "F9 druecken um den Rueckstoß kurzzeitig außer Kraft zu setzten" -ForegroundColor DarkBlue
write-host "F7 druecken um den Feinjustierungsmodus zu aktivieren" -ForegroundColor Cyan

# Initialisierung der globalen Variablen
$global:verticalspeed = 10
$global:horizontalspeed = 0 
$global:recoilDisabled = $false
$global:previousVerticalSpeed = $null
$global:previousHorizontalSpeed = $null
$global:preciseMode = $false

# Haupt-Loop des Skripts
while (-Not (IsKeyDown 121)) { # F10 zum Beenden des Skripts

    # Recoil-Steuerung aktivieren/deaktivieren
    if ($global:recoilDisabled) {
        if (IsKeyDown 120) { # F9 Taste
            # Rückstoß wieder aktivieren
            $global:recoilDisabled = $false
            if ($global:previousVerticalSpeed -ne $null -and $global:previousHorizontalSpeed -ne $null) {
                $global:verticalspeed = $global:previousVerticalSpeed
                $global:horizontalspeed = $global:previousHorizontalSpeed
                $global:previousVerticalSpeed = $null
                $global:previousHorizontalSpeed = $null
                Write-Host "Recoil aktiviert. Rückstoß gesetzt auf vertikal: $($global:verticalspeed), horizontal: $($global:horizontalspeed)" -ForegroundColor Green
            } else {
                Write-Host "Recoil aktiviert. Rückstoß-Wert war nicht gespeichert." -ForegroundColor Magenta
            }
            Start-Sleep -Milliseconds 200
        } else {
            Start-Sleep -Milliseconds 5
        }
    } else {
        # F9 Taste zum Deaktivieren des Recoils
        if (IsKeyDown 120) { 
            # Aktuellen Rückstoß speichern und deaktivieren
            $global:previousVerticalSpeed = $global:verticalspeed
            $global:previousHorizontalSpeed = $global:horizontalspeed
            $global:verticalspeed = 0
            $global:horizontalspeed = 0
            $global:recoilDisabled = $true
            Write-Host "Recoil deaktiviert. Rückstoß auf 0 gesetzt." -ForegroundColor Red
            Start-Sleep -Milliseconds 200
        }

        # F7 Taste für Feinjustierungsmodus
        if (IsKeyDown 118) {
            $global:preciseMode = -not $global:preciseMode
            $modeStatus = if ($global:preciseMode) {'aktiviert'} else {'deaktiviert'}
            Write-Host "Feinjustierungsmodus $modeStatus" -ForegroundColor Cyan
            Start-Sleep -Milliseconds 200
        }

        # Anpassungswert basierend auf dem Modus festlegen
        $adjustment = if ($global:preciseMode) {0.1} else {1}
        # Mausbewegung basierend auf dem Rückstoß
        if ((IsKeyDown 1) -and (IsKeyDown 2)) {
            [Win32]::mouse_event(1, $global:horizontalspeed, $global:verticalspeed, 0, 0) 
            Start-Sleep -Milliseconds 14
        }

        # Pfeiltasten-Steuerung
        foreach ($key in 37..40) {
            if (IsKeyDown $key) {
                switch ($key) {
                    37 { $global:horizontalspeed -= $adjustment } # Links
                    38 { $global:verticalspeed += $adjustment }   # Oben
                    39 { $global:horizontalspeed += $adjustment } # Rechts
                    40 { $global:verticalspeed -= $adjustment }   # Unten
                }
                # Kleine Werte runden
                if ([Math]::Abs($global:verticalspeed) -lt 0.001) {
                    $global:verticalspeed = 0
                }
                if ([Math]::Abs($global:horizontalspeed) -lt 0.001) {
                    $global:horizontalspeed = 0
                }
                # Werte auf 2 Dezimalstellen runden
                $global:verticalspeed = [Math]::Round($global:verticalspeed, 2)
                $global:horizontalspeed = [Math]::Round($global:horizontalspeed, 2)

                # Ausgabe der aktuellen Werte
                Write-Host "Rueckstoß gesetzt auf " -ForegroundColor Magenta -NoNewline
                write-host "Vertikal: $($global:verticalspeed) " -ForegroundColor Yellow -NoNewline
                write-host "Horizontal: $($global:horizontalspeed)" -ForegroundColor Magenta
                Start-Sleep -Milliseconds 200                        
            }
        }}}}
    2 {
        #Zweiter Main Switch Chase 
            do{
            clear-host 
            $loop2 = $true
            #Sub-level Switch
            write-host "1 druecken um die Recoil Liste zu bearbeiten"-ForegroundColor Cyan
            write-host "2 druecken um den Recoil per Gui zu steuern"-ForegroundColor Magenta
            write-host "e druecken um wieder zum Hauptmenü zu kommen"-ForegroundColor Green
            write-host "> " -NoNewline
            $Switch1 = Read-Host  
            switch ($Switch1)
            {
                1{ 
                    function Show-CSV {
                    param (
                    [string]$Path
                    ) 
                    $csv = Import-Csv $Path -Delimiter ","
                    $header = @("Operator", "StandardRecoil")
                    Write-Host ""
                    Write-Host "Liste:" -ForegroundColor Green
                    Write-Host ""
                    $table = @()
        
                    foreach ($row in $csv) {
                    $operator = $row.Operator
                    $recoil = $row.StandartRecoil
                    $table += @($operator, $recoil)
                    }
        
                    $columnWidths = @(
                    [PSCustomObject]@{ Header = $header[0]; Width = ($header[0]).Length },
                    [PSCustomObject]@{ Header = $header[1]; Width = ($header[1]).Length }
                    )
                    foreach ($row in $table) {
                    for ($i = 0; $i -lt $row.Count; $i++) {
                    $value = $row[$i]
                    $width = ($value).Length
                    if ($width -gt $columnWidths[$i].Width) {
                        $columnWidths[$i].Width = $width 
                        }
                    }
                    }
                
                    $headerLine = "+{0}+{1}+".Replace(" ", "-") -f ("-" * ($columnWidths[0].Width + 2)), ("-" * ($columnWidths[1].Width + 2))
        
                    Write-Host $headerLine -ForegroundColor Magenta
                    Write-Host ("| {0,-$($columnWidths[0].Width)} | {1,-$($columnWidths[1].Width)} |" -f $header[0], $header[1]) -ForegroundColor White
                    Write-Host $headerLine -ForegroundColor Magenta 
                    for ($i = 1; $i -lt $table.Count; $i += 2) {
                    $operator = $table[$i-1]
                    $recoil = $table[$i]
                    Write-Host ("| {0,-$($columnWidths[0].Width)} | {1,-$($columnWidths[1].Width)} |" -f $operator, $recoil) -ForegroundColor White
                    Write-Host $headerLine -ForegroundColor Magenta
                    }
                    }
                    do{
                    $loop3 = $true
                    clear-host 
                    if (!(Test-Path "C:\Program Files\Anti-Recoil\Recoil_log.csv")){
                    write-host "Bis jetzt wurde noch Kein Operator eingelesen, deshalb gibt es auch noch keine Anzeige"
                    }
                    else{
                    Show-CSV -Path "C:\Program Files\Anti-Recoil\Recoil_log.csv"
                    ""
                    ""
                    ""
                    }
                    write-host "+-----------------------------------------------+"-ForegroundColor Magenta
                    write-host "1 drücken um einen neuen Operator einzulesen"-ForegroundColor Cyan
                    write-host "2 drücken um einen Operator zu Löschen"-ForegroundColor Yellow
                    write-host "e drücken um in den vorherigen Switch zu gelangen"-ForegroundColor Gray
                    write-host "+-----------------------------------------------+"-ForegroundColor Magenta
                    write-host "> " -NoNewline -ForegroundColor cyan
                    $Insert1 = Read-Host
                    switch ($Insert1)
                    {
                    1{
                        # Prüfen, ob der Ordner vorhanden ist und gegebenenfalls erstellen
                        if (!(Test-Path "C:\Program Files\Anti-Recoil")) {
                        $null = New-Item -ItemType Directory -Path "C:\Program Files\Anti-Recoil" -ErrorAction SilentlyContinue
                        }
                        #Eingabe des Operators 
                        Write-Host "Bitte Operator eingeben bei dem der Standartwert gesetzt werden soll"-ForegroundColor Cyan
                        write-host "> " -NoNewline -ForegroundColor cyan
                        $Character = Read-Host
        
                        #Eingabe des Werts
                        Write-Host "Bitte den Standart Recoil Wert eingeben"-ForegroundColor Cyan
                        write-host "> " -NoNewline -ForegroundColor cyan
        
                        $Recoilvalue = Read-Host
        
                        #$logFile = "C:\Program Files\Anti-Recoil\Recoil_log.csv"
                        $logimport = Import-Csv -path "C:\Program Files\Anti-Recoil\Recoil_log.csv" -ErrorAction Ignore
        
                        # Überprüfen, ob der Operator bereits in der CSV-Datei vorhanden ist
                        if ($logimport) {
                        $existingEntry = $logimport | Where-Object {$_.Operator -eq $Character}
                        if ($existingEntry) {
                        # Wenn der Operator bereits vorhanden ist, aktualisieren Sie den Datensatz mit dem neuen Wert
                        $existingEntry.StandartRecoil = $Recoilvalue
                        $logimport | Export-Csv "C:\Program Files\Anti-Recoil\Recoil_log.csv" -NoTypeInformation -Force
                        } else {
                        # Wenn der Operator nicht vorhanden ist, fügen Sie einen neuen Datensatz hinzu
                        $logexport = [PSCustomObject]@{
                        Operator = $Character
                        StandartRecoil = $Recoilvalue
                        }
                        $logexport | Export-Csv "C:\Program Files\Anti-Recoil\Recoil_log.csv" -NoTypeInformation -Append
                        }
                        } else {
                        # Wenn die CSV-Datei leer ist, fügen Sie einen neuen Datensatz hinzu
                        $logexport = [PSCustomObject]@{
                        Operator = $Character
                        StandartRecoil = $Recoilvalue
                        }
                        $logexport | Export-Csv "C:\Program Files\Anti-Recoil\Recoil_log.csv" -NoTypeInformation -Append
                        }
                        }
                    2{
                        #Löschen
                        $csvPath = "C:\Program Files\Anti-Recoil\Recoil_log.csv"
    
                        # CSV-Datei einlesen
                        $csv = Import-Csv $csvPath -Delimiter ","
    
                        # Schleife starten
                        $loop4 = $true
                        do {
                        # Nach Eingabe des zu löschenden Operators fragen
                        write-host "Geben Sie den Namen des Operators ein, den Sie löschen möchten"-ForegroundColor cyan
                        write-host "> " -NoNewline -ForegroundColor cyan
                        $operatorToDelete = Read-Host 
                        # Überprüfen, ob der eingegebene Operator existiert
                        $found = $false
                        foreach ($row in $csv) {
                        if ($row -match $operatorToDelete) {
                        # Operator gefunden, Zeile aus CSV-Datei entfernen
                        $csv = $csv | Where-Object { $_ -ne $row }
                        $csv | Export-Csv $csvPath -NoTypeInformation
                        Write-Host "Operator '$operatorToDelete' wurde erfolgreich gelöscht." -ForegroundColor Green
                        $found = $true
                        $loop4 = $false
                        break
                        }
                        }
                        if (-not $found) {
                        # Operator existiert nicht
                        Write-Host "Operator '$operatorToDelete' existiert nicht in der CSV-Datei." -ForegroundColor Red
                        }
                        } while ($loop4)
                        }
                    e{
                        $loop3 = $false
                        }
                    E{
                        $loop3 = $false
                        }
                    default{
                        write-host "Ungültige Eingabe"-ForegroundColor Red
                        start-sleep -seconds 3
                        }
                        }#Switch Main->2->1->Eingeben oder Löschen
                        }while ($loop3) 
                        }
                2{    
                    $guiScript = 'C:\Program Files\Anti-Recoil\Gui.ps1'
                    if (-not (Test-Path $guiScript)) {
 @'
                    Add-Type -AssemblyName System.Windows.Forms
                    # Erstelle das Windows-Formular
                    $Form = New-Object System.Windows.Forms.Form
                    $Form.Text = "Operators"
                    $Form.Size = New-Object System.Drawing.Size(800, 600)
                    $Form.TransparencyKey = "#FF00FF"
                    $Form.BackColor = "#FF00FF"
                    $point = New-Object System.Drawing.Point(20, 20)
                    $Form.Location = $point
 
                    # Lade das CSV-File und bestimme die Anzahl der Knöpfe
                    $CsvFile = Import-Csv "C:\Program Files\Anti-Recoil\Recoil_log.csv"
                    $ButtonCount = $CsvFile.Count
 
                    # Füge die Knöpfe hinzu
                    $ButtonXPos = 20
                    $ButtonYPos = 20
                    $ButtonWidth = 100
                    $ButtonHeight = 30
                    foreach ($Row in $CsvFile) {
                    $Name = $Row.Operator
                    $Button = New-Object System.Windows.Forms.Button
                    $Button.Name = "Button$ButtonCount"
                    $Button.Text = $Name
                    $Button.Location = New-Object System.Drawing.Point($ButtonXPos, $ButtonYPos)
                    $Button.Size = New-Object System.Drawing.Size($ButtonWidth, $ButtonHeight)
                    $Button.FlatStyle = "Flat"
                    #$Button.FlatAppearance.BorderColor = "Magenta"
                    $Button.ForeColor = "Black"
                    $Button.BackColor = [System.Drawing.Color]::Gray
 
                    # Füge den Click-Handler hinzu
                    $Button.Add_Click({
                    $OperatorName1 = $this.Text
                    $recoilValue = ($CsvFile | Where-Object {$_.Operator -eq $OperatorName1}).StandartRecoil
                    $filePath = "C:\Program Files\Anti-Recoil\Tmp.txt"
                    if (Test-Path $filePath) {
                    Set-Content $filePath -value "$OperatorName1,$recoilValue"
                    } else {
                    New-Item $filePath -ItemType File -Value "$OperatorName1,$recoilValue"
                    }
                    New-Item -path "C:\Program Files\Anti-Recoil\trigger.txt"
                    })
     
                    $Form.Controls.Add($Button)
                    $ButtonCount++
                    if ($ButtonCount % 10 -eq 0) {
                    $ButtonXPos += $ButtonWidth + 10
                    $ButtonYPos = 20
                    }
                    else {
                    $ButtonYPos += $ButtonHeight + 10
                    }
                    }
                    # Passe die Größe des Formulars an, damit alle Buttons angezeigt werden
                    $MaxWidth = 20 + ($ButtonWidth + 10) * [Math]::Ceiling($ButtonCount / 10)
                    $MaxHeight = 20 + ($ButtonHeight + 10) * ([Math]::Min(10, $ButtonCount))
                    $Form.ClientSize = New-Object System.Drawing.Size($MaxWidth, $MaxHeight)
                    # Zeige das Formular an
                    $Form.ShowDialog()
'@ | Set-Content -Path $guiScript
                    }
                    $process = Start-Process -FilePath 'powershell.exe' -ArgumentList "-NoExit -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$guiScript`"" -PassThru
                    Function IsKeyDown($key) {
                    return [Convert]::ToBoolean([Win32]::GetAsyncKeyState($key) -band 0x8000)
                    }
                    # Dateipfad und Dateinamen definieren
                    $filePath = "C:\Program Files\Anti-Recoil\Tmp.txt"
 
                    # Schleife, die die Textdatei liest und den Recoil-Wert aktualisiert
                    while (-Not (IsKeyDown 121)) {
                    # Inhalte der Textdatei lesen und Name und Wert aufteilen
                    $data = Get-Content $filePath
                    $searchOperator, $recoilValue = $data -split ','
 
                    clear-host
                    Write-Host "Der Standartwert für den Operator '$searchOperator' ist '$recoilValue'"
                    Write-Host "F10 druecken um wieder ins Menue zu gelangen"-ForegroundColor Cyan
                    Write-Host "F9 druecken um den Rueckstoß zu freezen "-ForegroundColor DarkBlue  
     
                    $global:speed = $Recoilvalue
                    $global:speed -= 1
                    $global:speed += 1
                    $global:recoilDisabled = $false
                    $global:previousSpeed = $null
     
                    #Schleifen des Rueckstoßes 
                    while (-Not (IsKeyDown 121)) {
                    $trigger = "C:\Program Files\Anti-Recoil\trigger.txt"
                    if (Test-Path $trigger) {
                    remove-item "C:\Program Files\Anti-Recoil\trigger.txt"
                    $data = Get-Content $filePath
                    $searchOperator, $recoilValue = $data -split ','    
                    clear-host
                    Write-Host "Der Standartwert für den Operator '$searchOperator' ist '$recoilValue'"
                    Write-Host "F10 druecken um wieder ins Menue zu gelangen"-ForegroundColor Cyan
                    Write-Host "F9 druecken um den Rueckstoß zu freezen "-ForegroundColor DarkBlue  
                    $global:speed = $Recoilvalue
                    $global:speed -= 1
                    $global:speed += 1
                    $global:recoilDisabled = $false
                    $global:previousSpeed = $null
                    }
                    if ($global:recoilDisabled) {
                    if (IsKeyDown 120) {
                    $global:recoilDisabled = $false
                    if ($global:previousSpeed -ne $null) {
                     $global:speed = $global:previousSpeed
                     $global:previousSpeed = $null
                     Write-Host "Recoil aktiviert. Rueckstoß gesetzt auf $($global:speed)" -ForegroundColor Green
                    } else {
                     Write-Host "Recoil aktiviert. Rueckstoß-Wert war nicht gespeichert." -ForegroundColor magenta
                    }
                    Start-Sleep -Milliseconds 200
                    } else {
                    Start-Sleep -Milliseconds 5
                    }
                    } else {
                    if (IsKeyDown 120) {
                    $global:previousSpeed = $global:speed
                    $global:speed = 0
                    $global:recoilDisabled = $true
                    Write-Host "Recoil deaktiviert. Rueckstoß auf 0 gesetzt." -ForegroundColor Red
                    Start-Sleep -Milliseconds 200
                    } else {
                    if ((IsKeyDown 1) -and (IsKeyDown 2)) {
                     Start-Sleep -Milliseconds 14
                     #Hier wird die Maus nach unten Bewegt
                     [Win32]::mouse_event(1, 0, $global:speed, 0, 0) 
                    }
                    #Hier wird die Pfeieltaste nach oben eigelesen und der Wert demsntspraechend veraendert 
                    if (IsKeyDown 38) {
                     $global:speed += 1
                     Write-Host "Rueckstoß gesetzt auf $($global:speed)" -ForegroundColor magenta 
                     Start-Sleep -Milliseconds 200
                    }
                    #Hier wird die Pfeieltaste nach unten eigelesen und der Wert demsntspraechend veraendert 
                    if (IsKeyDown 40) {
                     $global:speed -= 1
                     Write-Host "Rueckstoß gesetzt auf $($global:speed)" -ForegroundColor magenta 
                     Start-Sleep -Milliseconds 200
                    }}}}}
                    # Beenden des Prozesses der gestarteten PowerShell-Instanz
                    if ($PSVersionTable.PSVersion.Major -ge 6) {
                    $process = Get-CimInstance Win32_Process | Where-Object { $_.CommandLine -like "*$guiScript*" }
                    } else {
                    $process = Get-WmiObject Win32_Process | Where-Object { $_.CommandLine -like "*$guiScript*" }
                    }
                    if ($process -ne $null) {
                    Stop-Process -Id $process.ProcessId
                    Write-Host "Process has been terminated."
                    } else {
                    Write-Host "Process is not running."
                    }
                    }
   
                    
    
                e {
                    $loop2 = $false
                    }
                E {
                    $loop2 = $false 
                    }
                default {
                    Write-Host "Ungueltige Eingabe" -ForegroundColor Red 
                    $loop2 = $true
                    start-sleep -Seconds 1 
                     }
                        }
                }while ($loop2)
                }


    3 {
        write-host "Prozesse werden gekillt" -Forgroundcolor cyan

        # Killen der Prozesse
        get-process Rainbow* | stop-process
        get-process Upc* | stop-process

        # Benachrichtigungen
        write-host "Rainbow wurde erfolgreich geschlossen" -ForegroundColor green
        write-host "Ubisoft wurde erfolgreich geschlossen" -ForegroundColor green

        # Starten von Rainbow
        start-process uplay://launch/635/0

        write-host ""
        write-host ""

        write-host "Rainbow wurde erfolgreich gestartet" -ForegroundColor Green 
        write-host "In 5 Sekunden gelangen sie wieder zum Main Switch" -ForegroundColor Green
        start-sleep -seconds 5
        }

    4{
        write-host "Reloading..." -ForegroundColor cyan
        start-sleep -Seconds 1}

    5 {exit}

    default {
        write-host "Ungueltige Eingabe" -ForegroundColor Red
        start-sleep -Seconds 1}
        }
}while ($Main_input -ne 4)

exit
