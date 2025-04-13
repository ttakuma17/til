import { OpenAPIHono } from '@hono/zod-openapi';
import { echoRoute } from './echoSchema'

const echoApi = new OpenAPIHono();

echoApi.openapi(echoRoute, async c => {
    const body = await c.req.valid('json');
    return c.json({ result: body.input });
});

export default echoApi;