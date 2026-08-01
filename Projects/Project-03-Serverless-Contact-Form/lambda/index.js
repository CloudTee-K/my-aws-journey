const { SESClient, SendEmailCommand } = require('@aws-sdk/client-ses');
const ses = new SESClient({ region: process.env.AWS_REGION });

function escapeHtml(str) {
    return String(str)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#x27;');
}

exports.handler = async (event) => {
    console.log('Received event:', JSON.stringify(event, null, 2));

    const senderEmail = process.env.SENDER_EMAIL;
    const recipientEmail = process.env.RECIPIENT_EMAIL;
    if (!senderEmail || !recipientEmail) {
        console.error('Missing required env vars: SENDER_EMAIL, RECIPIENT_EMAIL');
        return {
            statusCode: 500,
            headers: { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' },
            body: JSON.stringify({ success: false, message: 'Service configuration error.' })
        };
    }

    try {
        // Parse request body
        const body = JSON.parse(event.body);
        const { name, email, message } = body;
        
        // Validate input
        if (!name || !email || !message) {
            return {
                statusCode: 400,
                headers: {
                    'Access-Control-Allow-Origin': '*',
                    'Access-Control-Allow-Headers': 'Content-Type',
                    'Access-Control-Allow-Methods': 'POST,OPTIONS',
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    success: false,
                    message: 'Missing required fields: name, email, or message'
                })
            };
        }
        
        // Email validation
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(email)) {
            return {
                statusCode: 400,
                headers: {
                    'Access-Control-Allow-Origin': '*',
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    success: false,
                    message: 'Invalid email format'
                })
            };
        }
        
        // Email parameters
        const params = {
            Source: senderEmail,
            Destination: {
                ToAddresses: [recipientEmail]
            },
            Message: {
                Subject: {
                    Data: `Contact Form: Message from ${name}`
                },
                Body: {
                    Text: {
                        Data: `
Name: ${name}
Email: ${email}
Timestamp: ${new Date().toISOString()}

Message:
${message}

---
This message was sent via the serverless contact form (Project 3).
                        `
                    },
                    Html: {
                        Data: `
<!DOCTYPE html>
<html>
<head>
    <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 20px; border-radius: 5px 5px 0 0; }
        .content { background: #f9f9f9; padding: 20px; border: 1px solid #ddd; border-top: none; }
        .field { margin: 15px 0; }
        .label { font-weight: bold; color: #667eea; }
        .message-box { background: white; padding: 15px; border-left: 4px solid #667eea; margin-top: 15px; }
        .footer { text-align: center; color: #999; font-size: 12px; margin-top: 20px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>📧 New Contact Form Submission</h2>
        </div>
        <div class="content">
            <div class="field">
                <span class="label">From:</span> ${escapeHtml(name)}
            </div>
            <div class="field">
                <span class="label">Email:</span> <a href="mailto:${escapeHtml(email)}">${escapeHtml(email)}</a>
            </div>
            <div class="field">
                <span class="label">Received:</span> ${new Date().toLocaleString()}
            </div>
            <div class="message-box">
                <div class="label">Message:</div>
                <p>${escapeHtml(message).replace(/\n/g, '<br>')}</p>
            </div>
        </div>
        <div class="footer">
            Sent via AWS Lambda + SES (Project 3: Serverless Contact Form)
        </div>
    </div>
</body>
</html>
                        `
                    }
                }
            }
        };
        
        // Send email
        const result = await ses.send(new SendEmailCommand(params));
        console.log('Email sent successfully:', result.MessageId);
        
        return {
            statusCode: 200,
            headers: {
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Methods': 'POST,OPTIONS',
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                success: true,
                message: 'Email sent successfully!',
                messageId: result.MessageId
            })
        };
        
    } catch (error) {
        console.error('Error:', error);
        
        return {
            statusCode: 500,
            headers: {
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Methods': 'POST,OPTIONS',
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                success: false,
                message: 'Failed to send email. Please try again later.'
            })
        };
    }
};
