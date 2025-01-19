CREATE TABLE "orders" (
	"id" serial PRIMARY KEY NOT NULL,
	"paid" boolean NOT NULL,
	"subtotal" integer NOT NULL,
	"tax_amount" integer NOT NULL,
	"total" integer NOT NULL,
	"customer_id" serial NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
