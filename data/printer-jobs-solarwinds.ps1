 Param (
    $PrintQueue,
    $SizeLimit
)

if (!$PrintQueue -or !$SizeLimit) {
  Write-Error "Missing required arguments, Expected arguments like 'PRINTER-QUEUE,3000000000'"
  exit 1
}

try {
    $PrintJobs = Get-PrintJob -ComputerName "${Node.DNS}" -PrinterName $PrintQueue
} catch {
    Write-Error "Failed to get print jobs from queue: `"$PrintQueue`" at: `"${Node.DNS}`""
    exit 1
}

function BytesToHuman {
    Param (
        $Size
    )
    $1TB = [Math]::Pow(10,12)
    $1GB = [Math]::Pow(10,9)
    $1MB = [Math]::Pow(10,6)
    $1KB = [Math]::Pow(10,3)
    
    if ($Size -gt $1TB) { return "$([math]::Round($Size / $1TB, 2)) TB" }
    if ($Size -gt $1GB) { return "$([math]::Round($Size / $1GB, 2)) GB" }
    if ($Size -gt $1MB) { return "$([math]::Round($Size / $1MB, 2)) MB" }
    if ($Size -gt $1KB) { return "$([math]::Round($Size / $1KB, 2)) KB" }
    return "$($Size) B"
}

$JobsOverLimit = 0
$Iteration = 0
$DisplayMessages = $PrintJobs | ForEach {
    $Iteration++
    if ($_.Size -ge $SizeLimit) {
        $JobsOverLimit++
        "<tr style=`"color:Red;font-weight:bold;`"><td>$($_.Id)</td><td>$($_.JobStatus)</td><td>$(BytesToHuman($_.Size))</td></tr>"
    } else {
        "<tr><td>$($_.Id)</td><td>$($_.JobStatus)</td><td>$(BytesToHuman($_.Size))</td></tr>"
    }
}

$DisplayMessages = "<style type=`"text/css`">.tg{border-collapse:collapse;border-spacing:0;}.tg td{border-color:black;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px;overflow:hidden;padding:10px 5px;word-break:normal;}.tg th{border-color:black;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px;font-weight:normal;overflow:hidden;padding:10px 5px;word-break:normal;}.tg .tg-0lax{text-align:left;vertical-align:top}</style><table class=`"tg`"><thead><tr><th class=`"tg-0lax`">Job ID</th><th class=`"tg-0lax`">Status</th><th class=`"tg-0lax`">Size</th></tr></thead><tbody>$DisplayMessages</tbody></table>"
$DisplayMessages | Set-Clipboard

Write-Host "Message.AllJobs: $DisplayMessages"
Write-Host "Statistic.AllJobs: $(@($PrintJobs).Length)"
Write-Host "Statistic.JobsOverLimit: $($JobsOverLimit)"
if ($JobsOverLimit -gt 0) {
    exit 2
} else {
    exit 0
} 