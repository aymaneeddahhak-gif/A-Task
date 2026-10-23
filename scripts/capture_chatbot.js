const { chromium } = require('C:/Users/ch/Desktop/lesprojetes/portfolio/portfolio-next/node_modules/playwright');
const path = require('path');

async function capture() {
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
  await page.waitForTimeout(6500); // Wait for Flutter compilation + splash screen transition

  // Click Chatbot Tab (Tab 2)
  console.log('Clicking Chatbot tab...');
  await page.mouse.click(125, 844);
  await page.waitForTimeout(1500);

  // 1. Capture Screen 1 (Inspiration Left Screen)
  await page.screenshot({ path: path.join(__dirname, '../appscreenshot/05_ai_assistant_chatbot.png') });
  console.log('✓ Captured 05_ai_assistant_chatbot.png');

  // 2. Open Screen 2
  console.log('Opening Screen 2...');
  await page.mouse.click(206, 430);
  await page.waitForTimeout(1400);
  await page.screenshot({ path: path.join(__dirname, '../appscreenshot/05_ai_assistant_create_screen.png') });
  console.log('✓ Captured 05_ai_assistant_create_screen.png');

  // 3. Create a task via Surprise me + Send button!
  console.log('Clicking Surprise me and Send to CREATE task...');
  await page.mouse.click(85, 590); // Click surprise me
  await page.waitForTimeout(800);
  await page.mouse.click(365, 590); // Click blue send button
  await page.waitForTimeout(1500);
  await page.screenshot({ path: path.join(__dirname, '../appscreenshot/05_ai_assistant_created_task.png') });
  console.log('✓ Captured 05_ai_assistant_created_task.png');

  // 4. Switch to Templates / Manage Tab (READ, UPDATE, DELETE)
  console.log('Switching to Manage / CRUD Tab...');
  await page.mouse.click(290, 95); // Click Templates / Manage tab
  await page.waitForTimeout(1500);
  await page.screenshot({ path: path.join(__dirname, '../appscreenshot/05_ai_assistant_manage_crud.png') });
  console.log('✓ Captured 05_ai_assistant_manage_crud.png');

  await browser.close();
  console.log('=== Capture complete! ===');
}

capture().catch(err => {
  console.error(err);
  process.exit(1);
});
