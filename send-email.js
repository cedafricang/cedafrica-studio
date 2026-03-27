// CED Africa — Netlify Function: send-email
// Requires: RESEND_API_KEY environment variable in Netlify
// Domain: cedafrica.com must be verified in Resend dashboard

exports.handler = async function(event) {
  if (event.httpMethod !== "POST") {
    return { statusCode: 405, body: "Method not allowed" }
  }

  const headers = {
    "Access-Control-Allow-Origin": "*",
    "Content-Type": "application/json",
  }

  const apiKey = process.env.RESEND_API_KEY
  if (!apiKey) {
    return { statusCode: 500, headers, body: JSON.stringify({ error: "RESEND_API_KEY not configured" }) }
  }

  let payload
  try { payload = JSON.parse(event.body) }
  catch { return { statusCode: 400, headers, body: JSON.stringify({ error: "Invalid JSON" }) } }

  const { to, cc, subject, text, html, type } = payload
  if (!to || !subject || (!text && !html)) {
    return { statusCode: 400, headers, body: JSON.stringify({ error: "Missing: to, subject, text/html" }) }
  }

  // Branded HTML wrapper for plain-text emails
  const htmlBody = html || `<!DOCTYPE html><html><head><meta charset="UTF-8">
<style>body{font-family:-apple-system,sans-serif;background:#f8f7f5;margin:0;padding:0}
.wrap{max-width:600px;margin:40px auto;background:#fff;border-radius:12px;overflow:hidden;border:1px solid #e5e4e0}
.hdr{background:#1a1a1a;padding:18px 28px;display:flex;align-items:center;gap:10px}
.logo{background:#D97706;color:#fff;font-size:11px;font-weight:700;padding:3px 9px;border-radius:4px;letter-spacing:.07em}
.hdr span{color:#aaa;font-size:13px}
.body{padding:28px 32px}
pre{font-family:inherit;white-space:pre-wrap;line-height:1.75;font-size:14px;color:#1a1a1a;margin:0}
.foot{padding:18px 32px;background:#f8f7f5;border-top:1px solid #e5e4e0;font-size:11px;color:#999;line-height:1.7}
</style></head><body>
<div class="wrap">
  <div class="hdr"><div class="logo">CED AFRICA</div><span>AV Design Studio</span></div>
  <div class="body"><pre>${(text||"").replace(/</g,"&lt;").replace(/>/g,"&gt;")}</pre></div>
  <div class="foot">CED Africa — Custom Electronics Distribution Limited<br>
  17 Adeyemo Alakija St, Victoria Island, Lagos &nbsp;·&nbsp; design@ced.africa &nbsp;·&nbsp; 0808 666 2168</div>
</div></body></html>`

  try {
    const res = await fetch("https://api.resend.com/emails", {
      method: "POST",
      headers: { "Authorization": "Bearer "+apiKey, "Content-Type": "application/json" },
      body: JSON.stringify({
        from: "CED Africa Design Studio <noreply@cedafrica.com>",
        to:   Array.isArray(to) ? to : [to],
        ...(cc && cc.length > 0 ? { cc: Array.isArray(cc) ? cc : [cc] } : {}),
        subject,
        html: htmlBody,
      }),
    })
    const data = await res.json()
    if (!res.ok) {
      console.error("Resend error ["+type+"]:", data)
      return { statusCode: res.status, headers, body: JSON.stringify({ error: data.message||"Send failed", detail: data }) }
    }
    console.log("Email sent ["+type+"] to "+to+" | Resend ID: "+data.id)
    return { statusCode: 200, headers, body: JSON.stringify({ success: true, id: data.id }) }
  } catch(err) {
    console.error("Network error:", err)
    return { statusCode: 500, headers, body: JSON.stringify({ error: "Network error", message: err.message }) }
  }
}
