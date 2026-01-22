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

do {
    Clear-Host
    Write-Host "============================================"
    Write-Host "   MENU DE DRIVERS (PowerShell)"
    Write-Host "============================================"
    Write-Host "1 - Salvar drivers instalados (Backup)"
    Write-Host "2 - Restaurar drivers salvos (Reinstalar)"
    Write-Host "3 - Listar drivers instalados"
    Write-Host "4 - Sair"
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
            Read-Host "Pressione ENTER para voltar ao menu"
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
            Read-Host "Pressione ENTER para voltar ao menu"
        }
        "3" {
            Write-Host "Listando drivers instalados..."
            pnputil /enum-drivers
            Read-Host "Pressione ENTER para voltar ao menu"
        }
        "4" {
            Write-Host "Saindo..."
        }
        default {
            Write-Host "Opção inválida."
            Read-Host "Pressione ENTER para voltar ao menu"
        }
    }
} while ($opcao -ne "4")

