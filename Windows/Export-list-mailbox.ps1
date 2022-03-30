$ServerMail = Read-Host "Entrez le nom du serveur de mail"

Get-MailboxStatistics -Server $ServerMail | Select DisplayName, ItemCount, @{label="TotalItemSize(MB)";expression={$_.TotalItemSize.Value.ToMB()}} | Sort-Object TotalItemSize -Descending | Export-CSV c:\MBSizes.csv