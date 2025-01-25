import { pgTable, serial, index } from 'drizzle-orm/pg-core';
import { schemaTimestamps } from './schemaBase'
import { orderDetails } from './orderDetails';
import { options } from './options';

export const orderDetailOptions = pgTable('order_detail_options', {
    id: serial('id').primaryKey(),

    orderDetailId: serial('order_detail_id').references(() => orderDetails.id),
    optionId: serial('option_id').references(() => options.id),

    ...schemaTimestamps
}, (table) => [
    index("fk_options_order_detail_id_idx").on(table.orderDetailId),
    index("fk_option_id__idx").on(table.optionId),
]);