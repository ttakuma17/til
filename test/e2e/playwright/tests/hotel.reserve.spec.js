const { test, expect } = require('@playwright/test');

test('宿泊予約のフローをテスト', async ({ page }) => {
    await page.goto('https://hotel-example-site.takeyaqa.dev/ja/');
    await page.getByRole('link', { name: '宿泊予約' }).click();
    const page1Promise = page.waitForEvent('popup');
    await page.locator('.card-body > .btn').first().click();
    const page1 = await page1Promise;
    await page1.getByRole('textbox', { name: '宿泊日 必須' }).click();
    await page1.getByRole('link', { name: '30' }).click();
    await page1.getByRole('spinbutton', { name: '宿泊数 必須' }).fill('1');
    await page1.getByRole('spinbutton', { name: '人数 必須' }).fill('1');
    await page1.getByRole('checkbox', { name: '朝食バイキング' }).check();
    await page1.getByRole('textbox', { name: '氏名 必須' }).fill('テスト太郎');
    await page1.getByLabel('確認のご連絡 必須').selectOption('email');
    await page1.getByRole('textbox', { name: 'メールアドレス 必須' }).fill('test@example.com');
    await page1.locator('[data-test="submit-button"]').click();

    // 予約確認画面での検証
    await expect(page1.getByText('お得な特典付きプラン')).toBeVisible();
    await expect(page1.getByText(/2025年5月30日 〜 2025年5月31日 1泊/)).toBeVisible();
    await expect(page1.getByText('1名様')).toBeVisible();
    await expect(page1.getByText('朝食バイキング')).toBeVisible();
    await expect(page1.getByText('テスト太郎様')).toBeVisible();
    await expect(page1.getByText('メール：test@example.com')).toBeVisible();

    await page1.getByRole('button', { name: 'この内容で予約する' }).click();
    await expect(page1.getByRole('heading', { name: '予約を完了しました' })).toBeVisible();
    await expect(page1.getByText('ご来館、心よりお待ちしております。')).toBeVisible();
    await page1.getByRole('button', { name: '閉じる' }).click();
});
