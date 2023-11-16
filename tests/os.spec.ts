import { test, expect, PlaywrightTestConfig } from '@playwright/test';

declare var process : {
  env: {
    APPLICATION_URI_IP: string
  }
}

const BASE_URL = process.env["APPLICATION_URI_IP"];

test('test healthz', async ({ request, context }) => {
    const healthz = await request.get(`https://${BASE_URL}/`);
    expect(healthz.ok()).toBeTruthy();
    expect(await healthz.json()).toEqual(
        expect.objectContaining({
            State: "I'm alive!"
        })
    );
});

test('test os', async ({ request, context }) => {
  await context.tracing.start({ screenshots: true, snapshots: true });
  const os = await request.get(`https://${BASE_URL}/api/os`);
  expect(os.ok()).toBeTruthy();
  expect(await os.json()).toEqual(
    expect.objectContaining({
        Host: expect.any(String),
        OSType: "linux",
        Time: expect.any(String),
        Version: "v1"
    }));
  await context.tracing.stop({ path: 'trace.zip' });
});