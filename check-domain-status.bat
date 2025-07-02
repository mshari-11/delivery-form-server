@echo off
chcp 65001 >nul
color 0B
cls

echo ╔═══════════════════════════════════════════════════════════════════════╗
echo ║      🔍 Domain Status Check - www.firstlineon.com               ║
echo ╚═══════════════════════════════════════════════════════════════════════╝
echo.
echo Checking domain configuration...
echo ═══════════════════════════════════════════════════════════════════════
echo.

:: Initialize status counters
set /a passed=0
set /a failed=0
set /a warnings=0

:: ═══════════════════════════════════════════════
:: 1. Check DNS Configuration Method
:: ═══════════════════════════════════════════════
echo [1/6] Checking DNS Configuration Method...
nslookup -type=NS firstlineon.com 8.8.8.8 2>nul | findstr /i "vercel-dns.com" >nul
if %errorlevel% equ 0 (
    echo       ✅ Using Vercel Nameservers
    set /a passed+=1
) else (
    echo       ℹ️ Using A/CNAME Records
    set /a warnings+=1
)
echo.

:: ═══════════════════════════════════════════════
:: 2. Check DNS Resolution
:: ═══════════════════════════════════════════════
echo [2/6] Checking DNS Resolution...

:: Check root domain
nslookup firstlineon.com 8.8.8.8 >nul 2>&1
if %errorlevel% equ 0 (
    echo       ✅ firstlineon.com resolves
    set /a passed+=1
) else (
    echo       ❌ firstlineon.com does NOT resolve
    set /a failed+=1
)

:: Check www subdomain
nslookup www.firstlineon.com 8.8.8.8 >nul 2>&1
if %errorlevel% equ 0 (
    echo       ✅ www.firstlineon.com resolves
    set /a passed+=1
) else (
    echo       ❌ www.firstlineon.com does NOT resolve
    set /a failed+=1
)
echo.

:: ═══════════════════════════════════════════════
:: 3. Check HTTP/HTTPS Response
:: ═══════════════════════════════════════════════
echo [3/6] Checking HTTP/HTTPS Response...

:: Use PowerShell to check HTTPS
powershell -Command "try { $r = Invoke-WebRequest -Uri 'https://www.firstlineon.com' -Method Head -UseBasicParsing -TimeoutSec 5; if ($r.StatusCode -eq 200) { Write-Host '      ✅ HTTPS responds with status 200' } else { Write-Host '      ⚠️ HTTPS responds with status' $r.StatusCode } } catch { Write-Host '      ❌ HTTPS connection failed' }" 2>nul
if %errorlevel% equ 0 (
    set /a passed+=1
) else (
    set /a failed+=1
)
echo.

:: ═══════════════════════════════════════════════
:: 4. Check SSL Certificate
:: ═══════════════════════════════════════════════
echo [4/6] Checking SSL Certificate...
powershell -Command "try { $uri = 'https://www.firstlineon.com'; $req = [System.Net.HttpWebRequest]::Create($uri); $req.Method = 'HEAD'; $req.Timeout = 5000; $resp = $req.GetResponse(); Write-Host '      ✅ SSL certificate is valid'; $resp.Close() } catch { if ($_.Exception.Message -like '*SSL*' -or $_.Exception.Message -like '*certificate*') { Write-Host '      ❌ SSL certificate issue' } else { Write-Host '      ⚠️ Could not verify SSL' } }" 2>nul
if %errorlevel% equ 0 (
    set /a passed+=1
) else (
    set /a warnings+=1
)
echo.

:: ═══════════════════════════════════════════════
:: 5. Check Vercel Dashboard Status
:: ═══════════════════════════════════════════════
echo [5/6] Checking Vercel Configuration...
if exist DOMAIN-STATUS.txt (
    findstr /i "configured" DOMAIN-STATUS.txt >nul 2>&1
    if %errorlevel% equ 0 (
        echo       ✅ Domain configured in Vercel
        set /a passed+=1
    ) else (
        echo       ⚠️ Check Vercel Dashboard manually
        set /a warnings+=1
    )
) else (
    echo       ℹ️ Unable to check Vercel status
    set /a warnings+=1
)
echo.

:: ═══════════════════════════════════════════════
:: 6. Check Page Accessibility
:: ═══════════════════════════════════════════════
echo [6/6] Checking Page Accessibility...
set pages_ok=1

:: Check login page
powershell -Command "try { $r = Invoke-WebRequest -Uri 'https://www.firstlineon.com/login' -Method Head -UseBasicParsing -TimeoutSec 5; exit 0 } catch { exit 1 }" 2>nul
if %errorlevel% equ 0 (
    echo       ✅ /login page accessible
) else (
    echo       ❌ /login page NOT accessible
    set pages_ok=0
)

:: Check dashboard page
powershell -Command "try { $r = Invoke-WebRequest -Uri 'https://www.firstlineon.com/dashboard' -Method Head -UseBasicParsing -TimeoutSec 5; exit 0 } catch { exit 1 }" 2>nul
if %errorlevel% equ 0 (
    echo       ✅ /dashboard page accessible
) else (
    echo       ❌ /dashboard page NOT accessible
    set pages_ok=0
)

if %pages_ok% equ 1 (
    set /a passed+=1
) else (
    set /a failed+=1
)
echo.

:: ═══════════════════════════════════════════════
:: Summary Report
:: ═══════════════════════════════════════════════
echo ═══════════════════════════════════════════════════════════════════════
echo 📊 SUMMARY REPORT
echo ═══════════════════════════════════════════════════════════════════════
echo.
echo   ✅ Passed:   %passed% checks
echo   ⚠️ Warnings: %warnings% checks
echo   ❌ Failed:   %failed% checks
echo.

:: Determine overall status
if %failed% equ 0 (
    if %warnings% lss 2 (
        color 0A
        echo 🎉 OVERALL STATUS: EXCELLENT - Domain is fully configured!
    ) else (
        color 0E
        echo ⚠️ OVERALL STATUS: GOOD - Domain working with minor issues
    )
) else (
    color 0C
    echo ❌ OVERALL STATUS: NEEDS ATTENTION - Domain setup incomplete
)

echo.
echo ═══════════════════════════════════════════════════════════════════════
echo.

:: ═══════════════════════════════════════════════
:: Quick Actions Menu
:: ═══════════════════════════════════════════════
echo 🛠️ QUICK ACTIONS:
echo.
echo [1] Open Vercel Dashboard
echo [2] Check DNS Propagation
echo [3] Run Full DNS Test
echo [4] View DNS Records Guide
echo [5] Generate Status Report
echo [6] Exit
echo.
choice /C 123456 /N /M "Select option: "

if %ERRORLEVEL%==1 (
    echo.
    echo 🌐 Opening Vercel Dashboard...
    start https://vercel.com/dashboard
    timeout /t 2 >nul
    goto :end
)

if %ERRORLEVEL%==2 (
    echo.
    echo 🔍 Opening DNS Propagation Checker...
    start https://www.whatsmydns.net/#A/firstlineon.com
    timeout /t 1 >nul
    start https://www.whatsmydns.net/#NS/firstlineon.com
    timeout /t 2 >nul
    goto :end
)

if %ERRORLEVEL%==3 (
    echo.
    echo 🧪 Running Full DNS Test...
    call test-domain.bat
    goto :end
)

if %ERRORLEVEL%==4 (
    echo.
    echo 📋 Opening DNS Setup Guide...
    start domain-setup-guide.md
    timeout /t 2 >nul
    goto :end
)

if %ERRORLEVEL%==5 (
    echo.
    echo 📝 Generating Status Report...
    (
        echo Domain Status Report - %date% %time%
        echo ═══════════════════════════════════════════════════════
        echo.
        echo Domain: firstlineon.com
        echo Passed Checks: %passed%
        echo Warnings: %warnings%
        echo Failed Checks: %failed%
        echo.
        echo DNS Resolution:
        nslookup firstlineon.com 8.8.8.8 2>nul
        echo.
        echo Nameservers:
        nslookup -type=NS firstlineon.com 8.8.8.8 2>nul
    ) > domain-status-report.txt
    echo.
    echo ✅ Report saved to: domain-status-report.txt
    timeout /t 3 >nul
    goto :end
)

if %ERRORLEVEL%==6 (
    echo.
    echo 👋 Goodbye!
    exit
)

:end
echo.
echo ═══════════════════════════════════════════════════════════════════════
echo.
echo 💡 TIPS:
echo    • DNS changes can take 5-60 minutes to propagate
echo    • Clear browser cache if pages don't load: Ctrl+F5
echo    • Check from different networks to verify global access
echo.
pause