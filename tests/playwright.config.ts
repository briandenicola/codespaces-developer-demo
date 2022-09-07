import { PlaywrightTestConfig } from '@playwright/test';

declare var process : {
    env: {
        APPLICATION_URI: string
    }
}

const config: PlaywrightTestConfig = {
    timeout: 60000,
    use: {
        extraHTTPHeaders: {
            'Host': `${process.env.APPLICATION_URI}`,
        },
        contextOptions: {
            ignoreHTTPSErrors: true,
        },
    }
};
export default config;
