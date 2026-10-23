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

  // Capture Screen 1 (Inspiration Left Screen)
  await page.screenshot({ path: path.join(__dirname, '../appscreenshot/05_ai_assistant_chatbot.png') });
  console.log('✓ Captured 05_ai_assistant_chatbot.png');

  // Click on the creature (center of card) or chat button
  console.log('Clicking on creature / chat button to open Screen 2...');
  await page.mouse.click(206, 430);
  await page.waitForTimeout(1500);

  // Capture Screen 2 (Create your game / task UI)
  await page.screenshot({ path: path.join(__dirname, '../appscreenshot/05_ai_assistant_create_screen.png') });
  console.log('✓ Captured 05_ai_assistant_create_screen.png');

  // Also click "+ Surprise me" to demonstrate dynamic text generation!
  console.log('Clicking Surprise me button...');
  await page.mouse.click(85, 590);
  await page.waitForTimeout(800);
  await page.screenshot({ path: path.join(__dirname, '../appscreenshot/05_ai_assistant_create_with_prompt.png') });
  console.log('✓ Captured 05_ai_assistant_create_with_prompt.png');

  await browser.close();
}

capture().catch(err => {
  console.error(err);
  process.exit(1);
});
