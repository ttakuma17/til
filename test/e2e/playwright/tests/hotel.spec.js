import { test, expect } from '@playwright/test';

test('ホテル予約サイトにアクセスできること', async ({ page }) => {
    await page.goto('https://hotel-example-site.takeyaqa.dev/ja/');

    await expect(page).toHaveTitle(/HOTEL PLANISPHERE - テスト自動化練習サイト/);
});

test('会員登録リンクから遷移できること', async ({ page }) => {
    await page.goto('https://hotel-example-site.takeyaqa.dev/ja/');

    await page.getByRole('link', { name: '会員登録' }).click();

    await expect(page).toHaveTitle(/会員登録/);
    await expect(page).toHaveURL(/.*signup\.html/);
    await expect(page.getByLabel('メールアドレス')).toBeVisible();
    await expect(page.getByLabel('パスワード 必須')).toBeVisible();
});

test('会員登録フォームに入力して送信できること', async ({ page }) => {
    // 会員登録ページにアクセス
    await page.goto('https://hotel-example-site.takeyaqa.dev/ja/signup.html');

    // 必須項目の入力
    await page.getByLabel('メールアドレス').fill('testtttesttttest@example.com');
    await page.getByLabel('パスワード 必須').fill('password123');
    await page.getByLabel('パスワード（確認）').fill('password123');
    await page.getByLabel('氏名').fill('テスト太郎');

    // 任意項目の入力
    await page.getByLabel('住所').fill('東京都渋谷区1-1-1');
    await page.getByLabel('電話番号').fill('09012345678');
    await page.getByLabel('性別').selectOption('1');
    await page.getByLabel('生年月日').fill('1990-01-01');
    await page.getByLabel('お知らせを受け取る').check();
    await page.getByRole('button', { name: '登録' }).click();

    await expect(page).toHaveURL(/.*mypage\.html/);
});

// テスト用のヘルパー関数
async function verifyUserInfo(page, id, expectedValue) {
    await expect(page.locator(`#${id}`)).toHaveText(expectedValue);
}

test('会員登録後、マイページに登録情報が正しく表示されること', async ({ page }) => {

    const testData = {
        email: 'testtttesttttest@example.com',
        username: 'テスト太郎',
        address: '東京都渋谷区1-1-1',
        tel: '09012345678',
        gender: '1',
        birthday: '1990-01-01'
    };

    // 会員登録処理
    await page.goto('https://hotel-example-site.takeyaqa.dev/ja/signup.html');
    await page.getByLabel('メールアドレス').fill(testData.email);
    await page.getByLabel('パスワード 必須').fill('password123');
    await page.getByLabel('パスワード（確認）').fill('password123');
    await page.getByLabel('氏名').fill(testData.username);
    await page.getByLabel('住所').fill(testData.address);
    await page.getByLabel('電話番号').fill(testData.tel);
    await page.getByLabel('性別').selectOption(testData.gender);
    await page.getByLabel('生年月日').fill(testData.birthday);
    await page.getByLabel('お知らせを受け取る').check();
    await page.getByRole('button', { name: '登録' }).click();

    await expect(page).toHaveURL(/.*mypage\.html/);

    // マイページの表示を確認する
    await verifyUserInfo(page, 'email', testData.email);
    await verifyUserInfo(page, 'username', testData.username);
    await verifyUserInfo(page, 'rank', 'プレミアム会員');
    await verifyUserInfo(page, 'address', testData.address);
    await verifyUserInfo(page, 'tel', testData.tel);

    const genderText = testData.gender === '1' ? '男性' :
        testData.gender === '2' ? '女性' :
            testData.gender === '9' ? 'その他' : '回答しない';
    await verifyUserInfo(page, 'gender', genderText);

    await verifyUserInfo(page, 'birthday', /1990年1月1日/);
    await verifyUserInfo(page, 'notification', '受け取る');
});

