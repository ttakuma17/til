import { pgTable, serial, boolean, integer, varchar } from 'drizzle-orm/pg-core';
import { schemaTimestamps } from './schemaBase'
import { productCategories } from './productCategories';

export const products = pgTable('products', {
    id: serial('id').primaryKey(),
    name: varchar('name').notNull(),
    unitPrice: integer('unit_price').notNull(),
    productCategoryId: serial('product_category_id').references(() => productCategories.id),
    ...schemaTimestamps
});
