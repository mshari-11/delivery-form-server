# Agent Guide - Delivery Form Server

## Commands
- **Start dev**: `npm run dev` or `nodemon api/index.js`
- **Start prod**: `npm start` or `node api/index.js`
- **Build**: `npm run build` (echo only)
- **Deploy**: `npm run deploy` or `vercel --prod`

## Architecture
- **Backend**: Node.js/Express server with SQLite3 database
- **Main entry**: `api/index.js` (serverless) or `server.js` (local)
- **Database**: SQLite3 with tables: users, delivery_registrations, activity_logs
- **File storage**: Multer with disk storage (local) or memory storage (serverless)
- **Auth**: JWT tokens with bcrypt password hashing
- **Frontend**: Static HTML/CSS/JS in `public/` and root directory

## Code Style
- Arabic comments and error messages for user-facing content
- camelCase for variables and functions
- Express.js REST API patterns with `/api/` prefix
- Error handling with try-catch and proper HTTP status codes
- File uploads in separate directories: id-documents/, licenses/, face-photos/
- Use moment.js for date formatting
- Database queries with prepared statements for security

## Project Structure
- `api/` - Serverless functions (main logic)
- `public/` - Static assets
- `uploads/` - File storage (ignored in git)
- `vercel.json` - Deployment configuration
