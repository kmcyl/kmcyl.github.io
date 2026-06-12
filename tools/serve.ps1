param([int]$Port = 8743)
$root = Split-Path $PSScriptRoot -Parent
$mime = @{
    '.html'='text/html; charset=utf-8'; '.css'='text/css; charset=utf-8'
    '.js'='application/javascript; charset=utf-8'; '.json'='application/json'
    '.jpg'='image/jpeg'; '.jpeg'='image/jpeg'; '.png'='image/png'
    '.gif'='image/gif'; '.svg'='image/svg+xml'; '.pdf'='application/pdf'
    '.woff2'='font/woff2'; '.otf'='font/otf'; '.ico'='image/x-icon'; '.txt'='text/plain'
}
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$Port/")
$listener.Start()
Write-Host "Serving $root on http://localhost:$Port/"
while ($listener.IsListening) {
    $ctx = $listener.GetContext()
    try {
        $rel = [Uri]::UnescapeDataString($ctx.Request.Url.AbsolutePath.TrimStart('/'))
        if ([string]::IsNullOrEmpty($rel)) { $rel = 'index.html' }
        $path = Join-Path $root $rel
        if ((Test-Path $path -PathType Container)) { $path = Join-Path $path 'index.html' }
        $full = [IO.Path]::GetFullPath($path)
        if ($full.StartsWith($root, [StringComparison]::OrdinalIgnoreCase) -and (Test-Path $full -PathType Leaf)) {
            $bytes = [IO.File]::ReadAllBytes($full)
            $ext = [IO.Path]::GetExtension($full).ToLower()
            $ctx.Response.ContentType = if ($mime.ContainsKey($ext)) { $mime[$ext] } else { 'application/octet-stream' }
            $ctx.Response.ContentLength64 = $bytes.Length
            $ctx.Response.OutputStream.Write($bytes, 0, $bytes.Length)
        } else {
            $ctx.Response.StatusCode = 404
            $msg = [Text.Encoding]::UTF8.GetBytes('404')
            $ctx.Response.OutputStream.Write($msg, 0, $msg.Length)
        }
    } catch {} finally { try { $ctx.Response.Close() } catch {} }
}
