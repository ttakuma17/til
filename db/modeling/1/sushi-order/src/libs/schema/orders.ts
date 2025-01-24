import { pgTable, serial, boolean, integer, index } from 'drizzle-orm/pg-core';
import { customers } from './customers';
import { schemaTimestamps } from './schemaBase'

export const orders = pgTable('orders', {
    id: serial('id').primaryKey(),
    paid: boolean('paid').notNull(),
    subtotal: integer('subtotal').notNull(),
    taxAmount: integer('tax_amount').notNull(),
    total: integer('total').notNull(),
    customerId: serial('customer_id').references(() => customers.id),
    ...schemaTimestamps
}, (table) => {
    return {
        fkCustomerIdx: index("fk_customer_id_idx").on(table.customerId),
    }
});
