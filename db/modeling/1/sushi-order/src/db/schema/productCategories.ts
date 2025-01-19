import { pgTable, serial, boolean, integer, varchar } from 'drizzle-orm/pg-core';
import { schemaTimestamps } from './schemaBase'

export const productCategories = pgTable('product_categories', {
    id: serial('id').primaryKey(),
    name: varchar('name').notNull(),
    ...schemaTimestamps
});
