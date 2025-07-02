# ✅ Domain Verification Checklist

## 🎯 Project Information
- **Domain**: firstlineon.com
- **Project**: delivery-form-mshari  
- **Platform**: Vercel
- **Date**: _______________

---

## 📋 Pre-Setup Checklist

### 1. Vercel Account Access
- [ ] Can login to Vercel Dashboard
- [ ] Have access to `delivery-form-mshari` project
- [ ] Project is currently accessible at: https://delivery-form-mshari.vercel.app

### 2. Domain Provider Access
- [ ] Can login to domain registrar/DNS provider
- [ ] Have permission to modify DNS settings
- [ ] Current nameservers noted: _______________________
- [ ] Backup of current DNS records saved

### 3. Decision Made
- [ ] Option 1: Use Vercel Nameservers (Recommended)
- [ ] Option 2: Use A/CNAME Records with current DNS provider

---

## 🔧 Setup Process

### If Using Vercel Nameservers:
- [ ] Added domain in Vercel Dashboard
- [ ] Received Vercel nameserver addresses
- [ ] Updated nameservers at domain registrar:
  - [ ] ns1.vercel-dns.com
  - [ ] ns2.vercel-dns.com
- [ ] Saved confirmation/screenshot of change
- [ ] Start time noted: _______________

### If Using A/CNAME Records:
- [ ] Added both domains in Vercel Dashboard:
  - [ ] firstlineon.com
  - [ ] www.firstlineon.com
- [ ] Created A Record:
  - [ ] Type: A
  - [ ] Name: @ (or blank)
  - [ ] Value: 76.76.21.21
  - [ ] TTL: Auto/3600
- [ ] Created CNAME Record:
  - [ ] Type: CNAME
  - [ ] Name: www
  - [ ] Value: cname.vercel-dns.com
  - [ ] TTL: Auto/3600
- [ ] Removed conflicting records (old A, AAAA)
- [ ] Start time noted: _______________

---

## 🔍 DNS Propagation Verification

### Hour 1 (5-60 minutes after setup)
- [ ] Run `test-domain.bat`
- [ ] Check Vercel Dashboard status
- [ ] Test basic DNS resolution:
  ```cmd
  nslookup firstlineon.com
  nslookup www.firstlineon.com
  ```
- [ ] Results: _______________________

### Hour 2-4 (If not working yet)
- [ ] Clear local DNS cache:
  ```cmd
  ipconfig /flushdns
  ```
- [ ] Test from different network/device
- [ ] Check propagation status:
  - https://www.whatsmydns.net/#A/firstlineon.com
- [ ] Results: _______________________

### Hour 24-48 (For Nameserver changes)
- [ ] Verify nameservers have propagated
- [ ] All DNS records resolving correctly
- [ ] Results: _______________________

---

## 🌐 Website Functionality Tests

### Basic Access Tests
- [ ] https://firstlineon.com loads
- [ ] https://www.firstlineon.com loads
- [ ] Both redirect to same content
- [ ] No SSL certificate warnings

### Page Access Tests
- [ ] Homepage: https://www.firstlineon.com/
- [ ] Login Page: https://www.firstlineon.com/login
- [ ] Dashboard: https://www.firstlineon.com/dashboard
- [ ] Registration Form: https://www.firstlineon.com/form-complete.html

### SSL Certificate Verification
- [ ] Padlock icon shows in browser
- [ ] Certificate issued by Let's Encrypt
- [ ] Certificate covers both www and non-www
- [ ] No mixed content warnings

---

## 📱 Cross-Platform Testing

### Desktop Browsers
- [ ] Chrome
- [ ] Firefox
- [ ] Safari
- [ ] Edge

### Mobile Testing
- [ ] iOS Safari
- [ ] Android Chrome
- [ ] Different network (4G/5G)

### API Functionality
- [ ] Login API works: POST /api/login
- [ ] Registration API works: POST /api/register
- [ ] File uploads working
- [ ] Excel exports functioning

---

## 🛠️ Troubleshooting Checks

### If Site Not Loading:
- [ ] DNS records verified correct
- [ ] No typos in record values
- [ ] Waited sufficient propagation time
- [ ] Checked from multiple locations
- [ ] Verified Vercel project is live

### If SSL Not Working:
- [ ] Domain verified in Vercel
- [ ] Waited 15+ minutes after DNS
- [ ] Both www and non-www added
- [ ] No conflicting CAA records

### If Specific Pages 404:
- [ ] Check vercel.json configuration
- [ ] Verify cleanUrls setting
- [ ] Test with .html extension
- [ ] Check build output

---

## 📊 Performance Verification

### Speed Tests
- [ ] PageSpeed Insights score: _____/100
- [ ] Time to First Byte (TTFB): _____ms
- [ ] Fully loaded time: _____s

### Monitoring Setup
- [ ] Uptime monitoring configured
- [ ] SSL expiry alerts set
- [ ] DNS monitoring active

---

## 🎯 Final Verification

### Technical Checks
- [ ] All DNS records properly configured
- [ ] SSL certificate valid and active
- [ ] All pages accessible without errors
- [ ] APIs functioning correctly
- [ ] No console errors in browser

### Business Verification
- [ ] Stakeholders notified of new domain
- [ ] Internal systems updated with new URLs
- [ ] Documentation updated
- [ ] Support team briefed

### Backup & Recovery
- [ ] Old DNS settings documented
- [ ] Rollback plan prepared
- [ ] Contact info for support ready

---

## 📝 Sign-off

**Setup Completed By**: _______________________  
**Date/Time Completed**: _______________________  
**Verified By**: _______________________  
**Notes**: _______________________

---

## 🚀 Post-Launch Tasks

- [ ] Monitor for 24 hours
- [ ] Update any hardcoded URLs in code
- [ ] Set up redirects from old domain (if applicable)
- [ ] Update marketing materials
- [ ] Notify users of new domain
- [ ] Schedule follow-up review in 1 week

---

## 📞 Support Contacts

**Vercel Support**: support@vercel.com  
**Domain Registrar Support**: _______________________  
**Internal IT Contact**: _______________________  
**Project Manager**: _______________________

---

## 🌟 Available Helper Files

| File | Description | Usage |
|------|-------------|-------|
| `domain-setup-guide.md` | Complete DNS setup guide | Reference for both methods |
| `دليل-ربط-الدومين.md` | Arabic setup guide | For Arabic speakers |
| `test-domain.bat` | Advanced DNS tester | Run for comprehensive checks |
| `check-domain-status.bat` | Quick status check | Fast verification |
| `domain-test.html` | Interactive tester | Browser-based testing |
| `setup-domain.bat` | Interactive setup wizard | Step-by-step guidance |
| `fix-domain-dns.bat` | DNS fix utility | Troubleshooting helper |

---

**🎉 Congratulations on successful domain setup! 🎉**