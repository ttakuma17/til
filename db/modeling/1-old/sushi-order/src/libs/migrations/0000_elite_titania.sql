CREATE TABLE "campaigns" (
	"id" serial PRIMARY KEY NOT NULL,
	"name" varchar NOT NULL,
	"campaign_type" varchar NOT NULL,
	"discount" integer NOT NULL,
	"campaignStart" timestamp NOT NULL,
	"campaignEnd" timestamp NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "customers" (
	"id" serial PRIMARY KEY NOT NULL,
	"name" varchar(32) NOT NULL,
	"tel" varchar(15) NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "options" (
	"id" serial PRIMARY KEY NOT NULL,
	"name" varchar NOT NULL,
	"value" varchar NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "order_detail_campaigns" (
	"id" serial PRIMARY KEY NOT NULL,
	"order_detail_id" serial NOT NULL,
	"campaign_id" serial NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "order_details" (
	"id" serial PRIMARY KEY NOT NULL,
	"sales_unit_price" integer NOT NULL,
	"quantity" integer NOT NULL,
	"tax_rate" numeric NOT NULL,
	"order_id" serial NOT NULL,
	"product_id" serial NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "order_detail_options" (
	"id" serial PRIMARY KEY NOT NULL,
	"order_detail_id" serial NOT NULL,
	"option_id" serial NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
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
--> statement-breakpoint
CREATE TABLE "product_categories" (
	"id" serial PRIMARY KEY NOT NULL,
	"name" varchar NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "products" (
	"id" serial PRIMARY KEY NOT NULL,
	"name" varchar NOT NULL,
	"unit_price" integer NOT NULL,
	"product_category_id" serial NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
ALTER TABLE "order_detail_campaigns" ADD CONSTRAINT "order_detail_campaigns_order_detail_id_order_details_id_fk" FOREIGN KEY ("order_detail_id") REFERENCES "public"."order_details"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "order_detail_campaigns" ADD CONSTRAINT "order_detail_campaigns_campaign_id_campaigns_id_fk" FOREIGN KEY ("campaign_id") REFERENCES "public"."campaigns"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "order_details" ADD CONSTRAINT "order_details_order_id_orders_id_fk" FOREIGN KEY ("order_id") REFERENCES "public"."orders"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "order_details" ADD CONSTRAINT "order_details_product_id_products_id_fk" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "order_detail_options" ADD CONSTRAINT "order_detail_options_order_detail_id_order_details_id_fk" FOREIGN KEY ("order_detail_id") REFERENCES "public"."order_details"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "order_detail_options" ADD CONSTRAINT "order_detail_options_option_id_options_id_fk" FOREIGN KEY ("option_id") REFERENCES "public"."options"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "orders" ADD CONSTRAINT "orders_customer_id_customers_id_fk" FOREIGN KEY ("customer_id") REFERENCES "public"."customers"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "products" ADD CONSTRAINT "products_product_category_id_product_categories_id_fk" FOREIGN KEY ("product_category_id") REFERENCES "public"."product_categories"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "fk_campaign_order_detail_id_idx" ON "order_detail_campaigns" USING btree ("order_detail_id");--> statement-breakpoint
CREATE INDEX "fk_campaign_id_idx" ON "order_detail_campaigns" USING btree ("campaign_id");--> statement-breakpoint
CREATE INDEX "fk_order_id_idx" ON "order_details" USING btree ("order_id");--> statement-breakpoint
CREATE INDEX "fk_product_id_idx" ON "order_details" USING btree ("product_id");--> statement-breakpoint
CREATE INDEX "fk_options_order_detail_id_idx" ON "order_detail_options" USING btree ("order_detail_id");--> statement-breakpoint
CREATE INDEX "fk_option_id__idx" ON "order_detail_options" USING btree ("option_id");--> statement-breakpoint
CREATE INDEX "fk_customer_id_idx" ON "orders" USING btree ("customer_id");--> statement-breakpoint
CREATE INDEX "fk_product_category_id_idx" ON "products" USING btree ("product_category_id");