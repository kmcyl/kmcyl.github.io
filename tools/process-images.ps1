$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

$root = "C:\Users\kaitl\OneDrive\Documents\Archi showcase"
$pics = Join-Path $root "Archi Pictures"
$others = Join-Path $root "Others"
$out = Join-Path $root "website\assets\img"
New-Item -ItemType Directory -Force $out | Out-Null

function Convert-Image {
    param($src, $dstName, $maxEdge = 1800, $quality = 82)
    $dst = Join-Path $out $dstName
    $img = [System.Drawing.Image]::FromFile($src)
    try {
        # honor EXIF orientation (0x0112)
        if ($img.PropertyIdList -contains 0x0112) {
            $o = $img.GetPropertyItem(0x0112).Value[0]
            switch ($o) {
                3 { $img.RotateFlip([System.Drawing.RotateFlipType]::Rotate180FlipNone) }
                6 { $img.RotateFlip([System.Drawing.RotateFlipType]::Rotate90FlipNone) }
                8 { $img.RotateFlip([System.Drawing.RotateFlipType]::Rotate270FlipNone) }
            }
        }
        $w = $img.Width; $h = $img.Height
        $scale = [Math]::Min(1.0, $maxEdge / [double][Math]::Max($w, $h))
        $nw = [Math]::Max(1, [int]($w * $scale)); $nh = [Math]::Max(1, [int]($h * $scale))
        $bmp = New-Object System.Drawing.Bitmap($nw, $nh)
        $g = [System.Drawing.Graphics]::FromImage($bmp)
        $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
        $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
        $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
        $g.Clear([System.Drawing.Color]::White)
        $g.DrawImage($img, 0, 0, $nw, $nh)
        $g.Dispose()
        $enc = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/jpeg' }
        $ep = New-Object System.Drawing.Imaging.EncoderParameters(1)
        $ep.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, [long]$quality)
        $bmp.Save($dst, $enc, $ep)
        $bmp.Dispose()
        [pscustomobject]@{ name = $dstName; w = $nw; h = $nh }
    } finally { $img.Dispose() }
}

$map = @(
    # Core Studio Ex 1
    @{ s = "$pics\Showcased Archi Projects\core studio\Core Studio Ex 1\ex 1 model view axo.png";        d = "core1-model-axo.jpg" }
    @{ s = "$pics\Showcased Archi Projects\core studio\Core Studio Ex 1\ex 1 model view top.png";        d = "core1-model-top.jpg" }
    @{ s = "$pics\Showcased Archi Projects\core studio\Core Studio Ex 1\ex 1 model folding process.png"; d = "core1-process.jpg" }
    @{ s = "$pics\Showcased Archi Projects\core studio\Core Studio Ex 1\(1) ex 1 drawing axo.png";       d = "core1-axo.jpg" }
    @{ s = "$pics\Showcased Archi Projects\core studio\Core Studio Ex 1\ex 1 formas ai render 1.jpg";    d = "core1-render-1.jpg" }
    @{ s = "$pics\Showcased Archi Projects\core studio\Core Studio Ex 1\ex 1 formas ai render 2.jpg";    d = "core1-render-2.jpg" }
    @{ s = "$pics\Showcased Archi Projects\core studio\Core Studio Ex 1\ex 1 brief.png";                 d = "core1-brief.jpg"; m = 2000 }
    # Core Studio Ex 2
    @{ s = "$pics\Showcased Archi Projects\core studio\Core studio ex 2\(1) ex 2 drawing axo section.png"; d = "core2-axo-section.jpg"; m = 2200 }
    @{ s = "$pics\Showcased Archi Projects\core studio\Core studio ex 2\ex 2 formas ai render.jpg";       d = "core2-render.jpg" }
    @{ s = "$pics\Showcased Archi Projects\core studio\Core studio ex 2\ex 2 negative model axo.png";     d = "core2-neg-axo.jpg" }
    @{ s = "$pics\Showcased Archi Projects\core studio\Core studio ex 2\ex 2 negative model section.png"; d = "core2-neg-section.jpg" }
    @{ s = "$pics\Showcased Archi Projects\core studio\Core studio ex 2\ex 2 negative model top.jpg";     d = "core2-neg-top.jpg" }
    @{ s = "$pics\Showcased Archi Projects\core studio\Core studio ex 2\ex 2 positive model axo.png";     d = "core2-pos-axo.jpg" }
    @{ s = "$pics\Showcased Archi Projects\core studio\Core studio ex 2\ex 2 positive model top.png";     d = "core2-pos-top.jpg" }
    @{ s = "$pics\Showcased Archi Projects\core studio\Core studio ex 2\exercise 2 design brief.png";     d = "core2-brief.jpg"; m = 2200 }
    # Core Studio Ex 3
    @{ s = "$pics\Showcased Archi Projects\core studio\Core studio ex 3\(1) ex 3 drawing floor plan.png"; d = "core3-plan.jpg"; m = 2200 }
    @{ s = "$pics\Showcased Archi Projects\core studio\Core studio ex 3\(2) ex 3 drawing section.png";    d = "core3-section.jpg"; m = 2200 }
    @{ s = "$pics\Showcased Archi Projects\core studio\Core studio ex 3\20.png"; d = "core3-model-1.jpg" }
    @{ s = "$pics\Showcased Archi Projects\core studio\Core studio ex 3\21.png"; d = "core3-model-2.jpg" }
    @{ s = "$pics\Showcased Archi Projects\core studio\Core studio ex 3\22.png"; d = "core3-model-3.jpg" }
    @{ s = "$pics\Showcased Archi Projects\core studio\Core studio ex 3\23.png"; d = "core3-model-4.jpg" }
    @{ s = "$pics\Showcased Archi Projects\core studio\Core studio ex 3\ex 3 brief (1).png"; d = "core3-brief-1.jpg"; m = 2000 }
    @{ s = "$pics\Showcased Archi Projects\core studio\Core studio ex 3\ex 3 brief (2).png"; d = "core3-brief-2.jpg"; m = 2000 }
    # Core Studio Ex 4
    @{ s = "$pics\Showcased Archi Projects\core studio\Core studio ex 4\ex 4 model photos.png";         d = "core4-model.jpg" }
    @{ s = "$pics\Showcased Archi Projects\core studio\Core studio ex 4\ex 4 section model photos.png"; d = "core4-section-model.jpg" }
    @{ s = "$pics\Showcased Archi Projects\core studio\Core studio ex 4\ex 4 drawing.png"; d = "core4-drawing.jpg"; m = 2200 }
    @{ s = "$pics\Showcased Archi Projects\core studio\Core studio ex 4\site visit (1).jpg"; d = "core4-site-1.jpg" }
    @{ s = "$pics\Showcased Archi Projects\core studio\Core studio ex 4\site visit (2).jpg"; d = "core4-site-2.jpg" }
    @{ s = "$pics\Showcased Archi Projects\core studio\Core studio ex 4\site visit (3).jpg"; d = "core4-site-3.jpg" }
    # Structures / DDF
    @{ s = "$pics\Showcased Archi Projects\structures_ddf\canopy\photo_6152020278037385600_y.jpg"; d = "canopy-1.jpg" }
    @{ s = "$pics\Showcased Archi Projects\structures_ddf\canopy\photo_6152020278037385601_y.jpg"; d = "canopy-2.jpg" }
    @{ s = "$pics\Showcased Archi Projects\structures_ddf\canopy\photo_6152020278037385602_y.jpg"; d = "canopy-3.jpg" }
    @{ s = "$pics\Showcased Archi Projects\structures_ddf\canopy\photo_6152020278037385603_y.jpg"; d = "canopy-4.jpg" }
    @{ s = "$pics\Showcased Archi Projects\structures_ddf\canopy\photo_6152020278037385604_y.jpg"; d = "canopy-5.jpg" }
    @{ s = "$pics\Showcased Archi Projects\structures_ddf\ring\photo_6152020278037385597_y.jpg";   d = "ring-1.jpg" }
    @{ s = "$pics\Showcased Archi Projects\structures_ddf\ring\photo_6152020278037385598_y.jpg";   d = "ring-2.jpg" }
    @{ s = "$pics\Showcased Archi Projects\structures_ddf\ring\photo_6152020278037385599_y.jpg";   d = "ring-3.jpg" }
    @{ s = "$pics\Showcased Archi Projects\structures_ddf\stool\photo_6152020278037385589_w.jpg";  d = "stool-1.jpg" }
    @{ s = "$pics\Showcased Archi Projects\structures_ddf\stool\photo_6152020278037385605_y.jpg";  d = "stool-2.jpg" }
    @{ s = "$pics\Showcased Archi Projects\structures_ddf\stool\photo_6152020278037385606_y.jpg";  d = "stool-3.jpg" }
    # Spatial Design World - design thinking project
    @{ s = "$pics\Spatial Design World\design thinking project\IMG_2305.jpg"; d = "lattice-1.jpg" }
    @{ s = "$pics\Spatial Design World\design thinking project\png (2)";      d = "lattice-2.jpg" }
    # Spatial Design World - ex 1/2/3 apartment story
    @{ s = "$pics\Spatial Design World\ex 1\ex 1 png.png"; d = "spatial1-plan.jpg"; m = 2200 }
    @{ s = "$pics\Spatial Design World\ex 2\ex 2 png.png"; d = "spatial2-iso.jpg"; m = 2200 }
    @{ s = "$pics\Spatial Design World\ex 3\ex 3 png.png"; d = "spatial3-exterior.jpg"; m = 2200 }
    # Spatial Design World - ex 4 house
    @{ s = "$pics\Spatial Design World\ex 4\final_explodedaxo.jpg";       d = "dwelling-axo.jpg"; m = 2400 }
    @{ s = "$pics\Spatial Design World\ex 4\final_1ststoreyplan (1).jpg"; d = "dwelling-plan1.jpg"; m = 2400 }
    @{ s = "$pics\Spatial Design World\ex 4\final_2ndstoreyplan (1).jpg"; d = "dwelling-plan2.jpg"; m = 2400 }
    @{ s = "$pics\Spatial Design World\ex 4\png";     d = "dwelling-team.jpg" }
    @{ s = "$pics\Spatial Design World\ex 4\png (1)"; d = "dwelling-1.jpg" }
    @{ s = "$pics\Spatial Design World\ex 4\png (2)"; d = "dwelling-2.jpg" }
    @{ s = "$pics\Spatial Design World\ex 4\png (3)"; d = "dwelling-3.jpg" }
    @{ s = "$pics\Spatial Design World\ex 4\png (4)"; d = "dwelling-4.jpg" }
    @{ s = "$pics\Spatial Design World\ex 4\png (5)"; d = "dwelling-5.jpg" }
    @{ s = "$pics\Spatial Design World\ex 4\png (6)"; d = "dwelling-6.jpg" }
    # Global exchange - Bangkok
    @{ s = "$others\Global experience\bankok modernism trip\photo_6152020278037385582_y.jpg"; d = "bangkok-1.jpg" }
    @{ s = "$others\Global experience\bankok modernism trip\photo_6152020278037385583_y.jpg"; d = "bangkok-2.jpg" }
    @{ s = "$others\Global experience\bankok modernism trip\photo_6152020278037385584_y.jpg"; d = "bangkok-3.jpg" }
    @{ s = "$others\Global experience\bankok modernism trip\photo_6152020278037385585_y.jpg"; d = "bangkok-4.jpg" }
    @{ s = "$others\Global experience\bankok modernism trip\photo_6152020278037385587_y.jpg"; d = "bangkok-5.jpg" }
    @{ s = "$others\Global experience\bankok modernism trip\photo_6152020278037385588_y.jpg"; d = "bangkok-6.jpg" }
    @{ s = "$others\Global experience\bankok modernism trip\photo_6152020278037385590_y.jpg"; d = "bangkok-7.jpg" }
    @{ s = "$others\Global experience\bankok modernism trip\photo_6152020278037385591_w.jpg"; d = "bangkok-8.jpg" }
    @{ s = "$others\Global experience\bankok modernism trip\photo_6152020278037385593_w.jpg"; d = "bangkok-10.jpg" }
    @{ s = "$others\Global experience\bankok modernism trip\photo_6152020278037385594_w.jpg"; d = "bangkok-11.jpg" }
    @{ s = "$others\Global experience\bankok modernism trip\photo_6154272077851070284_y.jpg"; d = "bangkok-12.jpg" }
    @{ s = "$others\Global experience\bankok modernism trip\photo_6154272077851070285_y.jpg"; d = "bangkok-13.jpg" }
    @{ s = "$others\Global experience\bankok modernism trip\photo_6154272077851070288_y.jpg"; d = "bangkok-14.jpg" }
    # Global exchange - Surabaya
    @{ s = "$others\Global experience\surabaya pcu x sutd\photo_6152020278037385570_y.jpg";  d = "surabaya-1.jpg" }
    @{ s = "$others\Global experience\surabaya pcu x sutd\photo_6152020278037385573_y.jpg";  d = "surabaya-2.jpg" }
    @{ s = "$others\Global experience\surabaya pcu x sutd\photo_6154704675547057752_y.jpg";  d = "surabaya-3.jpg" }
    @{ s = "$others\Global experience\surabaya pcu x sutd\Screenshot 2026-06-13 002954.png"; d = "surabaya-4.jpg" }
    @{ s = "$others\Global experience\surabaya pcu x sutd\Screenshot 2026-06-13 003122.png"; d = "surabaya-5.jpg" }
    # Personal - alumni band
    @{ s = "$others\Personal Pictures\alumni concert band\photo_6152020278037385562_y.jpg"; d = "band-alumni-1.jpg" }
    @{ s = "$others\Personal Pictures\alumni concert band\photo_6152020278037385563_y.jpg"; d = "band-alumni-2.jpg" }
    @{ s = "$others\Personal Pictures\alumni concert band\photo_6152020278037385564_y.jpg"; d = "band-alumni-3.jpg" }
    @{ s = "$others\Personal Pictures\alumni concert band\photo_6152020278037385566_y.jpg"; d = "band-alumni-4.jpg" }
    @{ s = "$others\Personal Pictures\alumni concert band\photo_6152020278037385567_y.jpg"; d = "band-alumni-5.jpg" }
    @{ s = "$others\Personal Pictures\alumni concert band\photo_6152020278037385568_y.jpg"; d = "band-alumni-6.jpg" }
    # Personal - SUTD bands
    @{ s = "$others\Personal Pictures\SUTD Bands\IMG_0336.jpg";                     d = "band-1.jpg" }
    @{ s = "$others\Personal Pictures\SUTD Bands\photo_6152020278037385555_y.jpg";  d = "band-2.jpg" }
    @{ s = "$others\Personal Pictures\SUTD Bands\photo_6152020278037385556_y.jpg";  d = "band-3.jpg" }
    @{ s = "$others\Personal Pictures\SUTD Bands\photo_6152020278037385557_y.jpg";  d = "band-4.jpg" }
    @{ s = "$others\Personal Pictures\SUTD Bands\photo_6152020278037385558_y.jpg";  d = "band-5.jpg" }
    @{ s = "$others\Personal Pictures\SUTD Bands\photo_6152020278037385561_x.jpg";  d = "band-6.jpg" }
    @{ s = "$others\Personal Pictures\SUTD Bands\photo_6152020278037385574_y.jpg";  d = "band-7.jpg" }
    @{ s = "$others\Personal Pictures\SUTD Bands\_DSC6949.jpg";                     d = "band-8.jpg" }
    # Personal - SUTD orientation
    @{ s = "$others\Personal Pictures\SUTD Orientation\photo_6152020278037385549_y.jpg"; d = "orientation-1.jpg" }
    @{ s = "$others\Personal Pictures\SUTD Orientation\photo_6152020278037385550_y.jpg"; d = "orientation-2.jpg" }
    @{ s = "$others\Personal Pictures\SUTD Orientation\photo_6152020278037385552_y.jpg"; d = "orientation-3.jpg" }
    @{ s = "$others\Personal Pictures\SUTD Orientation\photo_6152020278037385554_y.jpg"; d = "orientation-4.jpg" }
    @{ s = "$others\Personal Pictures\SUTD Orientation\photo_6152020278037385569_y.jpg"; d = "orientation-5.jpg" }
)

$manifest = @()
foreach ($item in $map) {
    $maxEdge = 1800
    if ($item.ContainsKey('m')) { $maxEdge = $item.m }
    $manifest += Convert-Image -src $item.s -dstName $item.d -maxEdge $maxEdge
    Write-Host "ok $($item.d)"
}

# copy GIF and PDFs as-is
$pdfOut = Join-Path $root "website\assets\pdf"
New-Item -ItemType Directory -Force $pdfOut | Out-Null
Copy-Item "$pics\Spatial Design World\ex 2\Untitled (800 x 800 px) (1).gif" (Join-Path $out "spatial-anim.gif") -Force
Copy-Item "$pics\Spatial Design World\ex 1 floor plan.pdf" (Join-Path $pdfOut "spatial-ex1-floor-plan.pdf") -Force
Copy-Item "$pics\Spatial Design World\ex 2 iso interior drawing.pdf" (Join-Path $pdfOut "spatial-ex2-iso-interior.pdf") -Force
Copy-Item "$pics\Spatial Design World\ex 3 axo drawing.pdf" (Join-Path $pdfOut "spatial-ex3-axo-drawing.pdf") -Force

$manifest | ConvertTo-Json | Out-File (Join-Path $root "website\tools\manifest.json") -Encoding utf8
Write-Host "DONE - $($manifest.Count) images"
