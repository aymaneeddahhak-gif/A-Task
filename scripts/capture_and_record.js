const { chromium } = require('C:/Users/ch/Desktop/lesprojetes/portfolio/portfolio-next/node_modules/playwright');
const path = require('path');
const fs = require('fs');

const EDGE_PATH = 'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe';
const BASE_URL = 'http://localhost:4000';
const OUT_DIR = path.resolve(__dirname, '../appscreenshot');
const VIDEO_DIR = path.resolve(__dirname, '../videos');

if (!fs.existsSync(OUT_DIR)) fs.mkdirSync(OUT_DIR, { recursive: true });
if (!fs.existsSync(VIDEO_DIR)) fs.mkdirSync(VIDEO_DIR, { recursive: true });

async function run() {
  console.log('Launching Edge via Playwright...');
  const browser = await chromium.launch({
    executablePath: EDGE_PATH,
    headless: true
  });

  // ==========================================
  // PHASE 1: HIGH-RES RETINA SCREENSHOTS (412x890 @ 2x)
  // ==========================================
  console.log('--- Phase 1: Capturing High-Res Mobile Screenshots ---');
  const page = await browser.newPage({
    viewport: { width: 412, height: 890 },
    deviceScaleFactor: 2
  });

  await page.goto(BASE_URL);
  // Wait for splash screen (1.4s) + flutter warmup
  await page.waitForTimeout(5000);

  // 1. Home Dashboard - Default Morning Mode
  await page.screenshot({ path: path.join(OUT_DIR, '01_home_morning_dashboard.png') });
  console.log('✓ Captured 01_home_morning_dashboard.png');

  // Click 4-mode switcher: Afternoon mode (approx x=250, y=125)
  await page.mouse.click(250, 125);
  await page.waitForTimeout(1000);
  await page.screenshot({ path: path.join(OUT_DIR, '02_home_afternoon_sunset.png') });
  console.log('✓ Captured 02_home_afternoon_sunset.png');

  // Click 4-mode switcher: Night mode (approx x=345, y=125)
  await page.mouse.click(345, 125);
  await page.waitForTimeout(1000);
  await page.screenshot({ path: path.join(OUT_DIR, '03_home_night_mode.png') });
  console.log('✓ Captured 03_home_night_mode.png');

  // Switch back to Morning (x=155, y=125)
  await page.mouse.click(155, 125);
  await page.waitForTimeout(800);

  // Click Tab 1: Tasks / Schedule Timeline (x=85, y=844)
  await page.mouse.click(85, 844);
  await page.waitForTimeout(1200);
  await page.screenshot({ path: path.join(OUT_DIR, '04_task_schedule_timeline.png') });
  console.log('✓ Captured 04_task_schedule_timeline.png');

  // Click Tab 2: AI Assistant Chatbot (x=125, y=844)
  await page.mouse.click(125, 844);
  await page.waitForTimeout(1400);
  await page.screenshot({ path: path.join(OUT_DIR, '05_ai_assistant_chatbot.png') });
  console.log('✓ Captured 05_ai_assistant_chatbot.png (Screen 1 - Hero Creature)');

  // Click creature / chat button to open Screen 2 (Create Mode)
  await page.mouse.click(206, 430);
  await page.waitForTimeout(1200);
  await page.screenshot({ path: path.join(OUT_DIR, '05_ai_assistant_create_screen.png') });
  console.log('✓ Captured 05_ai_assistant_create_screen.png (Screen 2 - Create & Audio)');

  // Click back button to return to Screen 1
  await page.mouse.click(38, 70);
  await page.waitForTimeout(800);

  // Click Tab 3: Profile & Analytics (x=165, y=844)
  await page.mouse.click(165, 844);
  await page.waitForTimeout(1200);
  await page.screenshot({ path: path.join(OUT_DIR, '06_profile_analytics.png') });
  console.log('✓ Captured 06_profile_analytics.png');

  // Click Tab 4: Design Sandbox (x=205, y=844)
  await page.mouse.click(205, 844);
  await page.waitForTimeout(1200);
  await page.screenshot({ path: path.join(OUT_DIR, '07_design_sandbox.png') });
  console.log('✓ Captured 07_design_sandbox.png');

  // Click Tab 0: Back to Home (x=45, y=844)
  await page.mouse.click(45, 844);
  await page.waitForTimeout(1000);

  // Click Random Task Bolt Button (approx x=60, y=425)
  await page.mouse.click(60, 425);
  await page.waitForTimeout(1000);
  await page.screenshot({ path: path.join(OUT_DIR, '08_random_task_dialog.png') });
  console.log('✓ Captured 08_random_task_dialog.png');

  // Click outside to close dialog (x=200, y=100)
  await page.mouse.click(200, 100);
  await page.waitForTimeout(800);

  // Click New Task (+) Button on bottom nav (x=345, y=844)
  await page.mouse.click(345, 844);
  await page.waitForTimeout(1000);
  await page.screenshot({ path: path.join(OUT_DIR, '09_add_task_dialog.png') });
  console.log('✓ Captured 09_add_task_dialog.png');

  await page.close();

  // ==========================================
  // PHASE 2: DESKTOP SHOWCASE SCREENSHOT (1440x900 @ 2x)
  // ==========================================
  console.log('--- Phase 2: Capturing Desktop Showcase ---');
  const desktopPage = await browser.newPage({
    viewport: { width: 1440, height: 900 },
    deviceScaleFactor: 2
  });
  await desktopPage.goto(BASE_URL);
  await desktopPage.waitForTimeout(5000);
  await desktopPage.screenshot({ path: path.join(OUT_DIR, '10_desktop_device_mockup_showcase.png') });
  console.log('✓ Captured 10_desktop_device_mockup_showcase.png');
  await desktopPage.close();

  // ==========================================
  // PHASE 3: RECORD SHOWCASE VIDEO (Mobile Viewport)
  // ==========================================
  console.log('--- Phase 3: Recording Mobile Showcase Video ---');
  // Clear any existing recordings in VIDEO_DIR
  fs.readdirSync(VIDEO_DIR).forEach(f => {
    try { fs.unlinkSync(path.join(VIDEO_DIR, f)); } catch (_) {}
  });

  const recordContext = await browser.newContext({
    recordVideo: {
      dir: VIDEO_DIR,
      size: { width: 412, height: 890 }
    },
    viewport: { width: 412, height: 890 }
  });

  const recPage = await recordContext.newPage();
  await recPage.goto(BASE_URL);
  await recPage.waitForTimeout(4000);

  // Pause on Morning Home Dashboard
  await recPage.waitForTimeout(1800);

  // Switch to Afternoon Sunset Mode
  await recPage.mouse.click(250, 125);
  await recPage.waitForTimeout(2000);

  // Switch to Night Dark Sky Mode
  await recPage.mouse.click(345, 125);
  await recPage.waitForTimeout(2200);

  // Switch back to Auto / Morning
  await recPage.mouse.click(155, 125);
  await recPage.waitForTimeout(1600);

  // Scroll down tasks smoothly
  await recPage.mouse.wheel(0, 280);
  await recPage.waitForTimeout(1200);
  await recPage.mouse.wheel(0, -280);
  await recPage.waitForTimeout(1000);

  // Click Random Task
  await recPage.mouse.click(60, 425);
  await recPage.waitForTimeout(2000);
  // Close random task dialog
  await recPage.mouse.click(200, 100);
  await recPage.waitForTimeout(1000);

  // Click Tab 1: Schedule Timeline
  await recPage.mouse.click(85, 844);
  await recPage.waitForTimeout(2000);

  // Click Tab 2: AI Chatbot Assistant (Screen 1 - Creature & Stats)
  await recPage.mouse.click(125, 844);
  await recPage.waitForTimeout(2500);

  // Click Creature / Chat Button to open Screen 2 (Create Mode)
  await recPage.mouse.click(206, 430);
  await recPage.waitForTimeout(2200);

  // Click "+ Surprise me" to generate a prompt
  await recPage.mouse.click(85, 590);
  await recPage.waitForTimeout(2200);

  // Click back button to return to Screen 1
  await recPage.mouse.click(38, 70);
  await recPage.waitForTimeout(1500);

  // Click Tab 3: Profile & Analytics
  await recPage.mouse.click(165, 844);
  await recPage.waitForTimeout(2200);

  // Click Tab 0: Home
  await recPage.mouse.click(45, 844);
  await recPage.waitForTimeout(1400);

  // Click (+) New Task Dialog
  await recPage.mouse.click(345, 844);
  await recPage.waitForTimeout(2200);

  // Close context to finalize video writing
  await recordContext.close();
  await browser.close();

  console.log('✓ Video recording finished!');

  // Find the generated webm file
  const videoFiles = fs.readdirSync(VIDEO_DIR).filter(f => f.endsWith('.webm'));
  if (videoFiles.length > 0) {
    const rawVideo = path.join(VIDEO_DIR, videoFiles[0]);
    const finalWebm = path.resolve(__dirname, '../atask_showcase.webm');
    const portfolioVideo = 'C:/Users/ch/Desktop/lesprojetes/portfolio/portfolio-next/public/videos/atask_showcase.webm';

    // Copy to workspace and portfolio
    fs.copyFileSync(rawVideo, finalWebm);
    console.log(`✓ Copied showcase video to: ${finalWebm}`);

    fs.copyFileSync(rawVideo, portfolioVideo);
    console.log(`✓ Synced to portfolio video at: ${portfolioVideo}`);
  }

  console.log('=== ALL SCREENSHOTS AND VIDEO COMPLETE! ===');
}

run().catch(err => {
  console.error('Error executing runner:', err);
  process.exit(1);
});
