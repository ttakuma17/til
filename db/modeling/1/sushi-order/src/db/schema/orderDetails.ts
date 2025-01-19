import { pgTable, serial, integer, numeric } from 'drizzle-orm/pg-core';
import { schemaTimestamps } from './schemaBase'
import { orders } from './orders';
import { products } from './products';

export const orderDetails = pgTable('order_details', {
    id: serial('id').primaryKey(),
    salesUnitPrice: integer('sales_unit_price').notNull(),
    quantity: integer('quantity').notNull(),
    taxRate: numeric('tax_rate').notNull(),
    orderId: serial('order_id').references(() => orders.id),
    productId: serial('product_id').references(() => products.id),
    // campaignId: serial('campaign_id').references(() => campaigns.id), いらん
    ...schemaTimestamps
});