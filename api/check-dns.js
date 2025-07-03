module.exports = async (req, res) => {
    const dns = require('dns').promises;
    const https = require('https');
    
    // إعداد CORS
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
    res.setHeader('Content-Type', 'application/json');
    
    // معالجة OPTIONS request
    if (req.method === 'OPTIONS') {
        res.status(200).end();
        return;
    }
    
    const domain = 'firstlineon.com';
    const requiredNS = ['ns1.vercel-dns.com', 'ns2.vercel-dns.com'];
    
    try {
        const result = {
            domain: domain,
            timestamp: new Date().toISOString(),
            nameservers: {
                current: [],
                required: requiredNS,
                isCorrect: false
            },
            site: {
                isAccessible: false,
                statusCode: 0,
                url: `https://${domain}`
            },
            isConnected: false,
            message: ''
        };
        
        // فحص Nameservers
        try {
            const nameservers = await dns.resolveNs(domain);
            result.nameservers.current = nameservers.map(ns => ns.toLowerCase());
            
            // التحقق من وجود Vercel nameservers
            result.nameservers.isCorrect = result.nameservers.current.some(ns => 
                ns.includes('vercel-dns')
            );
        } catch (dnsError) {
            console.log('DNS lookup error:', dnsError.message);
            result.nameservers.current = [];
            result.message = 'لم يتم العثور على معلومات DNS للنطاق';
        }
        
        // فحص حالة الموقع
        try {
            const siteStatus = await checkSiteStatus(`https://${domain}`);
            result.site = {
                ...result.site,
                ...siteStatus
            };
        } catch (siteError) {
            console.log('Site check error:', siteError.message);
        }
        
        // فحص موقع www أيضاً
        try {
            const wwwStatus = await checkSiteStatus(`https://www.${domain}`);
            result.wwwSite = {
                isAccessible: wwwStatus.accessible,
                statusCode: wwwStatus.statusCode,
                url: `https://www.${domain}`
            };
        } catch (wwwError) {
            console.log('WWW site check error:', wwwError.message);
        }
        
        // تحديد الحالة النهائية
        result.isConnected = result.nameservers.isCorrect && result.site.isAccessible;
        
        // إنشاء رسالة مناسبة
        if (result.isConnected) {
            result.message = 'النطاق مربوط ويعمل بشكل صحيح! 🎉';
        } else if (result.nameservers.isCorrect && !result.site.isAccessible) {
            result.message = 'Nameservers صحيحة لكن الموقع لم يُفعل بعد. قد يستغرق الأمر 10-30 دقيقة.';
        } else if (result.nameservers.current.length === 0) {
            result.message = 'لم يتم العثور على nameservers. تأكد من أن النطاق مسجل وأن DNS نشط.';
        } else {
            result.message = 'يرجى تحديث Nameservers في موقع مزود النطاق إلى nameservers Vercel.';
        }
        
        // إضافة معلومات إضافية
        result.debug = {
            currentNSCount: result.nameservers.current.length,
            hasVercelNS: result.nameservers.isCorrect,
            mainSiteAccessible: result.site.isAccessible,
            wwwSiteAccessible: result.wwwSite?.isAccessible || false
        };
        
        res.status(200).json(result);
        
    } catch (error) {
        console.error('Check DNS Error:', error);
        res.status(500).json({
            error: 'Failed to check DNS',
            message: error.message,
            timestamp: new Date().toISOString(),
            domain: domain
        });
    }
};

// دالة مساعدة لفحص حالة الموقع
function checkSiteStatus(url) {
    return new Promise((resolve) => {
        const urlObj = new URL(url);
        const options = {
            hostname: urlObj.hostname,
            port: 443,
            path: urlObj.pathname,
            method: 'HEAD',
            timeout: 5000,
            headers: {
                'User-Agent': 'FirstLine-DNS-Checker/1.0'
            }
        };
        
        const req = https.request(options, (res) => {
            resolve({
                accessible: res.statusCode >= 200 && res.statusCode < 400,
                statusCode: res.statusCode,
                headers: res.headers
            });
        });
        
        req.on('error', (error) => {
            console.log('Site check error:', error.message);
            resolve({
                accessible: false,
                statusCode: 0,
                error: error.message
            });
        });
        
        req.on('timeout', () => {
            req.destroy();
            resolve({
                accessible: false,
                statusCode: 0,
                error: 'Request timeout'
            });
        });
        
        req.end();
    });
}