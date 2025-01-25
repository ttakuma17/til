import { reset, seed } from 'drizzle-seed';
import dotenv from 'dotenv';
import * as schema from './schema'
import { drizzle } from 'drizzle-orm/node-postgres';
import { count } from 'console';

dotenv.config();
const db = drizzle(process.env.DATABASE_URL!);

async function main() {
    await reset(db, schema);
    await seed(db, schema).refine((f) => ({
        customers: {
            count: 5,
            columns: {
                name: f.fullName(),
                tel: f.phoneNumber({ template: "###-####-####" })
            }
        },
        orders: {
            count: 10,
            colmuns: {
                paid: f.boolean(),
                subtotal: f.number({ minValue: 0, maxValue: 12000 }),
                taxAmount: f.number({ minValue: 0, maxValue: 1200 }),
                total: f.number({ minValue: 0, maxValue: 13200 }),
            },
        },
        orderDetails: {
            orderDetails: {
                count: 20,
                columns: {
                    salesUnitPrice: f.number({ minValue: 100, maxValue: 1000 }),
                    quantity: f.number({ minValue: 1, maxValue: 10 }),
                    taxRate: f.number({ minValue: 0, maxValue: 10, precision: 10 }),
                }
            },
        },
        options: {
            options: {
                count: 5,
                columns: {
                    name: f.string(),
                    value: f.string(),
                }
            },
        },
        orderDetailOptions: {
            count: 20,
            columns: {

            }
        },
        campaigns: {
            count: 5,
            columns: {
                name: f.string(),
                campaignType:
                    f.valuesFromArray({
                        values: [
                            { weight: 0.75, values: ["fixed"] },
                            { weight: 0.25, values: ["percentage"] },
                        ]
                    }),
                discount: f.number({ minValue: 0, maxValue: 100 }),
                campaignStart: f.timestamp(),
                campaignEnd: f.timestamp(),
            }
        },
        orderDetailCampaigns: {
            count: 20,
            columns: {}
        },
        products: {
            count: 20, // 適当な値に調整してください
            columns: {
                name: f.string(),
                unitPrice: f.number({ minValue: 100, maxValue: 2000 }),
            }
        },
        productCategories: {
            count: 5,
            columns: {
                name: f.string(),
            }
        }
    }));
}

main();