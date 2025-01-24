import { swaggerUI } from '@hono/swagger-ui';
import { serve } from '@hono/node-server'
import { OpenAPIHono } from '@hono/zod-openapi'
import echoApi from './routes/echo/echoApi';
import getCustomer from './routes/customer/getCustomerRoute';
import createCustomer from './routes/customer/createCustomerRoute';

const app = new OpenAPIHono()

app
  .route('/api', echoApi)
  .route('/api', getCustomer)
  .route('/api', createCustomer)
  .doc('/specification', {
    openapi: '3.0.0',
    info: {
      title: 'API',
      version: '1.0.0',
    },
  }).get('/doc', swaggerUI({
    url: '/specification',
  }));

const port = 3000
console.log(`Server is running on http://localhost:${port}`)

serve({
  fetch: app.fetch,
  port
})


export type EchoApiType = typeof echoApi
