Add-Type -AssemblyName System.Windows.Forms

function Escolher-Pasta {
    $dialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $dialog.Description = "Selecione a pasta"
    if ($dialog.ShowDialog() -eq "OK") {
        return $dialog.SelectedPath
    } else {
        return $null
    }
}

Write-Host "============================================"
Write-Host "   MENU DE DRIVERS (PowerShell)"
Write-Host "============================================"
Write-Host "1 - Salvar drivers instalados (Backup)"
Write-Host "2 - Restaurar drivers salvos (Reinstalar)"
Write-Host "3 - Listar drivers instalados"
Write-Host "============================================"

$opcao = Read-Host "Digite a opcao desejada"

switch ($opcao) {
    "1" {
        $pasta = Escolher-Pasta
        if ($pasta) {
            Write-Host "Exportando drivers para $pasta ..."
            pnputil /export-driver * "$pasta"
            Write-Host "Backup concluído! Drivers salvos em $pasta"
        } else {
            Write-Host "Operação cancelada."
        }
    }
    "2" {
        $pasta = Escolher-Pasta
        if ($pasta) {
            Write-Host "Restaurando drivers da pasta $pasta ..."
            pnputil /add-driver "$pasta\*.inf" /install
            Write-Host "Restauração concluída!"
        } else {
            Write-Host "Operação cancelada."
        }
    }
    "3" {
        Write-Host "Listando drivers instalados..."
        pnputil /enum-drivers
    }
    default {
        Write-Host "Opção inválida."
    }
}
