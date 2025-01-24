import { OpenAPIHono, createRoute, z } from '@hono/zod-openapi';

const getCustomer = new OpenAPIHono();

const paramsSchema = z.object({ id: z.string() });
const UserSchema = z.object({
    id: z.string(),
    name: z.string(),
    tel: z.string(),
});

const getCustomerRoute = createRoute({
    path: '/customer/{id}',
    method: 'get',
    description: 'お客様の情報取得',
    request: {
        params: paramsSchema,
    },
    responses: {
        200: {
            description: 'OK',
            content: {
                'application/json': {
                    schema: UserSchema,
                },
            },
        },
    },
});

getCustomer.openapi(getCustomerRoute, async c => {
    const { id } = await c.req.valid('param');
    const userData = {
        id,
        name: 'John Doe',
        tel: '070-1111-2222',
    };

    return c.json(userData);
});

export default getCustomer;
