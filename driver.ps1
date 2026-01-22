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

$opcao = ""
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
            $pasta = Escolher-Pasta
            if ($pasta) {
        $arquivo = Join-Path $pasta "drivers.txt"
                Write-Host "Gerando lista de drivers em $arquivo ..."
                pnputil /enum-drivers | Out-File -FilePath $arquivo -Encoding UTF8
                Write-Host "Lista concluída! Arquivo salvo em $arquivo"
            } else {
                Write-Host "Operação cancelada."
            }
            Read-Host "Pressione ENTER para voltar ao menu"
        }

        "4" {
            Write-Host "Saindo..."
            exit   # <- aqui funciona corretamente
        }
        default {
            Write-Host "Opção inválida."
            Read-Host "Pressione ENTER para voltar ao menu"
        }
    }
} while ($opcao -ne "4")
