import { pgTable, serial, index } from 'drizzle-orm/pg-core';
import { schemaTimestamps } from './schemaBase'
import { orderDetails } from './orderDetails';
import { campaigns } from './campaigns';

export const orderDetailCampaigns = pgTable('order_detail_campaigns', {
    id: serial('id').primaryKey(),

    orderDetailId: serial('order_detail_id').references(() => orderDetails.id),
    campaginId: serial('campaign_id').references(() => campaigns.id),

    ...schemaTimestamps
}, (table) => [
    index("fk_campaign_order_detail_id_idx").on(table.orderDetailId),
    index("fk_campaign_id_idx").on(table.campaginId),
]);