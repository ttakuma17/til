import { OpenAPIHono } from '@hono/zod-openapi';
import { route } from './echoSchema'

const echoApi = new OpenAPIHono();

echoApi.openapi(route, async c => {
    const body = await c.req.valid('json');
    return c.json({ result: body.input });
});

export default echoApi;