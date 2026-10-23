const { chromium } = require('C:/Users/ch/Desktop/lesprojetes/portfolio/portfolio-next/node_modules/playwright');
const path = require('path');

async function captureSplash() {
  const browser = await chromium.launch({
    channel: 'msedge',
    headless: true
  });

  const page = await browser.newPage({
    viewport: { width: 412, height: 890 },
    deviceScaleFactor: 2
  });

  console.log('Navigating to http://localhost:4000 ...');
  await page.goto('http://localhost:4000');
  
  // Capture immediately on first loading (App Icon Splash Screen!)
  await page.waitForTimeout(600);
  await page.screenshot({ path: path.join(__dirname, '../appscreenshot/00_app_splash_screen.png') });
  console.log('✓ Captured 00_app_splash_screen.png');

  await browser.close();
}

captureSplash().catch(err => {
  console.error(err);
  process.exit(1);
});
