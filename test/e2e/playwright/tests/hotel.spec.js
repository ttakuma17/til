import { test, expect } from '@playwright/test';

test('ホテル予約サイトにアクセスできること', async ({ page }) => {
    await page.goto('https://hotel-example-site.takeyaqa.dev/ja/');

    await expect(page).toHaveTitle(/HOTEL PLANISPHERE - テスト自動化練習サイト/);
});