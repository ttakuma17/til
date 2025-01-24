import { OpenAPIHono, createRoute, z } from '@hono/zod-openapi';

const createCustomer = new OpenAPIHono();

const createCustomerBodySchema = z.object({
    name: z.string().min(1),
    tel: z.string().regex(/^\d{2,4}-\d{2,4}-\d{4}$/),
});

const createCustomerRoute = createRoute({
    path: '/customer',
    method: 'post',
    description: 'お客様情報の作成',
    request: {
        body: {
            content: {
                'application/json': {
                    schema: createCustomerBodySchema,
                },
            }
        },
    },
    responses: {
        201: {
            description: 'Created',
            content: {
                'application/json': {
                    schema: z.object({
                        result: z.literal('success'),
                    }),
                },
            },
        },
    },
});

createCustomer.openapi(createCustomerRoute, async c => {
    const body = await c.req.valid('json');
    const newCustomerId = '12345';

    return c.json({ result: 'success' as const }, 201);
})

export default createCustomer;
