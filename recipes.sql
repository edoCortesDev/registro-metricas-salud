-- ================================================
-- RECETAS / RECIPES — Auto-generated SQL
-- 102 recipes | ES + DE | breakfast / lunch / snack
-- ================================================

-- Tabla recipes
CREATE TABLE IF NOT EXISTS recipes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name_es text NOT NULL,
  name_de text NOT NULL,
  category text CHECK (category IN ('breakfast','lunch','snack','dinner')),
  calories_per_serving float,
  protein float,
  fat float,
  carbs float,
  servings_note_es text,
  servings_note_de text,
  instructions_es text,
  instructions_de text,
  image_url text,
  created_at timestamptz DEFAULT now()
);

-- Tabla recipe_ingredients
CREATE TABLE IF NOT EXISTS recipe_ingredients (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  recipe_id uuid REFERENCES recipes(id) ON DELETE CASCADE,
  name_es text,
  name_de text,
  quantity float,
  unit text,
  sort_order int
);

-- Tabla meal_plans
CREATE TABLE IF NOT EXISTS meal_plans (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES profiles(id) ON DELETE CASCADE,
  date date NOT NULL,
  recipe_id uuid REFERENCES recipes(id),
  servings int DEFAULT 1,
  created_at timestamptz DEFAULT now()
);

-- Tabla shopping_lists
CREATE TABLE IF NOT EXISTS shopping_lists (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES profiles(id) ON DELETE CASCADE,
  date date NOT NULL,
  items jsonb NOT NULL DEFAULT '[]',
  created_at timestamptz DEFAULT now()
);

-- Tabla water_logs
CREATE TABLE IF NOT EXISTS water_logs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES profiles(id) ON DELETE CASCADE,
  date date NOT NULL,
  glasses int DEFAULT 0,
  created_at timestamptz DEFAULT now(),
  UNIQUE (user_id, date)
);

-- RLS
ALTER TABLE recipes ENABLE ROW LEVEL SECURITY;
ALTER TABLE recipe_ingredients ENABLE ROW LEVEL SECURITY;
ALTER TABLE meal_plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE shopping_lists ENABLE ROW LEVEL SECURITY;
ALTER TABLE water_logs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view recipes" ON recipes FOR SELECT TO authenticated USING (true);
CREATE POLICY "Anyone can view ingredients" ON recipe_ingredients FOR SELECT TO authenticated USING (true);
CREATE POLICY "Users manage own meal_plans" ON meal_plans FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users manage own shopping_lists" ON shopping_lists FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users manage own water_logs" ON water_logs FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

-- ================================================
-- INSERT RECIPES
-- ================================================

INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '8d9c67d7-939b-4ac4-9c16-df25edcca168',
  'Pan de Calabacín Bajo en Carbohidratos',
  'Low Carb Zucchini Brot',
  'breakfast',
  101.0,
  7.9,
  6.3,
  2.5,
  '1 PAN, 12 REBANADAS',
  '1 BROT, 12 SCHEIBEN',
  'Precalentar el horno a 180 grados (aire caliente). Lavar el calabacín, cortar los extremos y rallarlo finamente. Colocar el calabacín rallado en un paño de cocina y exprimir la humedad con las manos. Mezclar la harina de almendra, los huevos, la levadura en polvo y el aceite de coco en un tazón. Añadir el calabacín, el xilitol, la canela y la sal y revolver. Picar las nueces en trozos pequeños e incorporarlas a la masa. Poner la masa en un molde para pan y hornear durante 30-40 minutos.',
  'Backofen auf 180 Grad (Umluft) vorheizen. Zucchini waschen, Enden abschneiden und klein raspeln. Die geraspelte Zucchini in ein Küchentuch legen und die Feuchtigkeit mit den Händen auspressen. Mandelmehl, Eier, Backpulver und das Kokosöl in einer Schüssel vermischen. Zucchini, Xylit, Zimt und Salz dazugeben und verrühren. Walnüsse klein hacken und unter den Teig heben. Teig in eine Brotform geben und für 30-40 Minuten backen.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '7ea965c6-017d-466f-8035-ee71ee778ff9',
  'Oopsies Bajos en Carbohidratos',
  'Low Carb Oopsies',
  'breakfast',
  102.0,
  7.5,
  6.8,
  1.5,
  '8 OOPSIES',
  '8 OOPSIES',
  'Precalentar el horno a 160 grados (aire caliente). Separar los huevos y batir las claras a punto de nieve. Mezclar las yemas junto con el quark, la sal y la levadura en polvo. Incorporar las claras a la mezcla y revolver. Cubrir una bandeja de horno con papel para hornear, formar 8 oopsies planos con la mezcla y colocarlos uno al lado del otro en la bandeja. Hornear durante aprox. 20 minutos.',
  'Backofen auf 160 Grad (Umluft) vorheizen. Eier trennen und das Eiklar steif schlagen. Eigelbe zusammen mit dem Quark, Salz und Backpulver vermischen. Eiklar unter die Masse heben und umrühren. Ein Backblech mit Backpapier auslegen, aus der Masse 8 flache Oopsies formen und nebeneinander auf das Backblech legen. Für ca. 20 Minuten backen.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  'f3d9cfb3-0d4a-4e10-a9d1-0561a2dad1ea',
  'Panecillos de Harina de Almendra',
  'Mandelmehl Brötchen',
  'breakfast',
  143.0,
  14.5,
  8.2,
  1.9,
  '6 PANECILLOS',
  '6 BRÖTCHEN',
  'Precalentar el horno a 180 grados (aire). Mezclar la harina de almendra, las cáscaras de psyllium, la sal y la levadura en polvo en un bol. Separar los huevos, se necesitan cuatro claras y dos yemas, las otras dos yemas no se necesitan. Agregar los huevos junto con el agua tibia a la mezcla de harina de almendra y revolver hasta obtener una masa homogénea. Picar finamente las avellanas e incorporarlas a la masa. Cubrir una bandeja de horno con papel de hornear y formar seis panecillos con la masa. Colocar los panecillos uno al lado del otro en la bandeja y hornear durante 40-50 minutos.',
  'Backofen auf 180 Grad (Umluft) vorheizen. Mandelmehl, Flohsamenschalen, Salz und Backpulver in einer Schüssel vermischen. Eier trennen, davon werden vier Eiklar und zwei Eigelb benötigt, zwei Eigelbe werden nicht benötigt. Eier zusammen mit dem warmen Wasser zur Mandelmehlmischung geben und verrühren bis eine homogene Masse entsteht. Haselnüsse klein hacken und unter die Masse heben. Ein Backblech mit Backpapier auslegen und aus der Masse sechs Brötchen formen. Brötchen nebeneinander auf das Backblech legen und 40-50 Minuten backen.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '018f66b7-0147-4bdf-9fc4-456dd7b9c223',
  'Panecillos de sésamo bajos en carbohidratos',
  'Low Carb Sesam Brötchen',
  'breakfast',
  157.0,
  16.7,
  9.0,
  1.4,
  '2 PANECILLOS',
  '2 BRÖTCHEN',
  'Precalentar el horno a 200 grados (calor superior/inferior). Poner la mozzarella y el queso crema en una pequeña olla y derretir al baño maría. Poner el queso derretido en un bol. Agregar el huevo al bol y mezclar. Añadir la harina de almendra, la levadura en polvo y la sal y revolver. Cubrir una bandeja de horno con papel de hornear y formar dos panecillos con la masa. (La masa es muy pegajosa, antes de darles forma, engrasarse ligeramente las manos con aceite.) Colocar los panecillos uno al lado del otro en la bandeja y espolvorear con semillas de sésamo. El sésamo también puede omitirse. Hornear durante 13-15 minutos.',
  'Backofen auf 200 Grad (Ober-/Unterhitze) vorheizen. Mozzarella und Frischkäse in einen kleinen Topf geben und über einem Wasserbad schmelzen. Geschmolzenen Käse in eine Schüssel geben. Ei in die Schüssel geben und vermischen. Mandelmehl, Backpulver und Salz dazugeben und verrühren. Ein Backblech mit Backpapier auslegen und aus dem Teig zwei Brötchen formen. (Der Teig ist sehr klebrig, vor dem formen die Hände leicht mit Öl einölen.) Brötchen nebeneinander auf das Backblech legen und mit Sesamsamen bestreuen. Der Sesam kann auch weggelassen werden. Für 13-15 Minuten backen.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '017a31e9-8eb3-44fb-bdc0-d1bb2ab15aec',
  'Pan de linaza',
  'Leinsamen Brot',
  'breakfast',
  163.0,
  12.1,
  10.6,
  3.5,
  '1 PAN, 18 REBANADAS',
  '1 BROT, 18 SCHEIBEN',
  'Precalentar el horno a 180 grados (aire circulante). Poner el requesón, los huevos y la harina de almendras en un bol y mezclar con una batidora de mano. Añadir las semillas de lino molidas, el salvado de avena, la harina de algarroba, el bicarbonato de sodio y la sal y mezclar. Poner la masa del pan en un molde para pan y espolvorear con semillas de lino y pipas de girasol. Hornear durante 40-45 minutos. Dejar enfriar después de hornear.',
  'Backofen auf 180 Grad (Umluft) vorheizen. Quark, Eier und das Mandelmehl in eine Schüssel geben und mit einem Handrührgerät vermischen. Geschrotete Leinsamen, Haferkleie, Johannisbrotkernmehl, Natron und Salz dazugeben und verrühren. Brotteig in eine Brotform geben und mit Leinsamen und Sonnenblumenkernen bestreuen. Für 40-45 Minuten backen. Nach dem Backen abkühlen lassen.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  'fe99ad2f-7cee-4f15-b077-346e869edaed',
  'Panecillos Low Carb',
  'Low Carb Brötchen',
  'breakfast',
  171.0,
  11.0,
  13.1,
  1.0,
  '2 PANECILLOS',
  '2 BRÖTCHEN',
  'Precalentar el horno a 200 grados (calor arriba y abajo). Poner el requesón y la mantequilla (a temperatura ambiente) en un bol y mezclar con una batidora de mano. Añadir la harina de almendras, el huevo, la levadura en polvo, las cáscaras de psyllium y la sal y mezclar. Cubrir una bandeja de horno con papel de horno. Amasar la masa con las manos, formar dos panecillos y colocarlos en la bandeja. Hornear durante 12-15 minutos.',
  'Backofen auf 200 Grad (Ober-/Unterhitze) vorheizen. Quark und Butter (Zimmertemperatur) in eine Schüssel geben und mit einem Handrührgerät vermischen. Mandelmehl, Ei, Backpulver, Flohsamenschalen und Salz dazugeben und verrühren. Ein Backblech mit Backpapier auslegen. Den Teig mit den Händen verkneten, zwei Brötchen formen und auf das Backblech legen. 12- 15 Minuten backen.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '61733671-159e-433f-8ba7-7300d357168e',
  'Panecillos Low Carb de Queso',
  'Low Carb Käse Brötchen',
  'breakfast',
  177.0,
  9.3,
  13.7,
  1.8,
  '6 PANECILLOS',
  '6 BRÖTCHEN',
  'Poner los huevos, las almendras y el quark en un bol y mezclar con una batidora de mano. Añadir la harina de coco, el psyllium en polvo, la levadura y la sal. Mezclar bien y dejar reposar la masa durante 20 minutos. Precalentar el horno a 160 grados (calor arriba/abajo) y cubrir una bandeja de horno con papel para hornear. Formar seis panecillos redondos con la masa y colocarlos en la bandeja. Hornear durante 10 minutos, espolvorear los panecillos con queso y hornear durante 10-15 minutos más.',
  'Eier, Mandeln und Quark in eine Schüssel geben und mit einem Handrührgerät vermischen. Kokosmehl, Flohsamenschalenpulver, Backpulver und Salz dazugeben. Gut vermischen und den Teig 20 Minuten ruhen lassen. Backofen auf 160 Grad (Ober-/Unterhitze) vorheizen und ein Backblech mit Backpapier auslegen. Aus dem Teig sechs runde Brötchen formen und auf das Backblech legen. Für 10 Minuten backen, Brötchen mit Käse bestreuen und für weitere 10-15 Minuten backen.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  'df37368c-dd71-4e2d-9e54-465ef0e96c7d',
  'Bagels de Sésamo Bajos en Carbohidratos',
  'Low Carb Sesam Bagels',
  'breakfast',
  217.0,
  18.1,
  14.1,
  3.4,
  '6 BAGELS',
  '6 BAGELS',
  'Precalentar el horno a 200 grados (calor arriba/abajo). Poner las semillas de lino dorado, la harina de coco y la levadura en un bol y mezclar. Cortar la mozzarella en trozos pequeños y ponerla junto con el quark en una olla. Derretir a fuego lento removiendo constantemente. Añadir la mezcla de mozzarella derretida a la mezcla de harina y remover. Agregar los dos huevos y la sal y amasar con las manos. Envolver la masa en film transparente y meter en el refrigerador durante 3-4 horas. Amasar la masa de nuevo y dividirla en seis piezas iguales. Dar forma de bagel a cada pieza. Cubrir una bandeja de horno con papel para hornear y distribuir los bagels sobre ella. Poner la yema de huevo en un vaso y batirla con un tenedor. Añadir la leche y mezclar. Pintar los bagels con la mezcla de yema y espolvorear con sésamo. Hornear durante 20-25 minutos.',
  'Backofen auf 200 Grad (Ober-/Unterhitze) vorheizen. Goldleinsamen, Kokosmehl und Backpulver in eine Schüssel geben und vermischen. Mozzarella klein schneiden und zusammen mit dem Quark in einen Topf geben. Bei kleiner Hitze unter ständigem Rühren zum Schmelzen bringen. Geschmolzene Mozzarella-Mischung zur Mehlmischung geben und verrühren. Die beiden Eier und Salz dazugeben und mit den Händen verkneten. Teig in Frischhaltefolie einwickeln und für 3-4 Stunden in den Kühlschrank stellen. Teig nochmals durchkneten und in sechs gleichgroße Stücke teilen. Teigstücke in eine Bagelform formen. Ein Backblech mit Backpapier auslegen und darauf die Bagels verteilen. Eigelb in ein Glas geben und mit einer Gabel verquirlen. Milch dazugeben und verrühren. Die Bagels mit der Eigelbmischung bestreichen und mit Sesam bestreuen. Für 20-25 Minuten backen.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  'cc9308e3-6331-48bc-b402-bf27dcbff18a',
  'Bol de Bayas y Chía',
  'Beeren Chia Bowl',
  'breakfast',
  251.0,
  10.4,
  13.9,
  19.4,
  '1 PORCIÓN',
  '1 PORTION',
  'Poner el yogur, las frambuesas y las moras en un bol y hacer puré. Reservar un puñado de bayas para el topping. Exprimir el limón, añadir el zumo y mezclar. Poner el yogur en un bol y distribuir las semillas de calabaza, las semillas de girasol y las bayas de goji sobre el yogur. Por último, añadir las bayas restantes sobre el yogur.',
  'Joghurt, Himbeeren und Brombeeren in eine Schüssel geben und pürieren. Eine handvoll Beeren für das Topping zur Seite legen. Zitrone auspressen und den Saft dazugeben und verrühren. Joghurt in eine Schüssel geben und Kürbiskerne, Sonnenblumenkerne und Goji Beeren über dem Joghurt verteilen. Zum Schluss die restlichen Beeren auf den Joghurt geben.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '2ba2b2be-6ede-4b3e-b87f-b80a8c9f25f2',
  'Tortilla de espinacas con tomates',
  'Spinatomlett mit Tomaten',
  'breakfast',
  283.0,
  29.8,
  13.7,
  7.8,
  '1 PORCIÓN',
  '1 PORTION',
  'Poner los huevos, las claras, la sal y la pimienta en un bol y batir con un tenedor. Lavar las espinacas, escurrirlas y cortarlas en trozos pequeños. Incorporar las espinacas a la mezcla de huevos. Calentar la mantequilla en una sartén y verter la mezcla de huevos. Tapar y dejar cuajar a fuego lento durante 6-8 minutos. Cortar los tomates por la mitad y servir con la tortilla. Sazonar con sal y pimienta. Cortar la cebolleta en trozos pequeños y esparcir sobre los tomates.',
  'Eier, Eiweiß, Salz und Pfeffer in eine Schüssel geben und mit einer Gabel verquirlen. Spinat waschen, abtropfen lassen und klein schneiden. Spinat in die Eimasse unterrühren. Butter in einer Pfanne erhitzen und die Eimasse hinein gießen. Zugedeckt 6-8 Minuten auf geringer Hitze stocken lassen. Tomaten halbieren und mit dem Omlett servieren. Mit Salz und Pfeffer würzen. Frühlingszwiebel klein schneiden und über die Tomaten streuen.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '16103d3d-a772-49cf-a9e0-3028cb4bb56a',
  'Huevos fritos con bacon',
  'Spiegelei mit Bacon',
  'breakfast',
  289.0,
  16.5,
  22.6,
  4.9,
  '1 PORCIÓN',
  '1 PORTION',
  'Calentar el aceite de oliva en la sartén y freír las lonchas de bacon por ambos lados hasta que estén crujientes. Reservar el bacon y mantenerlo caliente. A fuego medio, cascar dos huevos en la sartén, sazonar con sal y pimienta y freír (sin darles la vuelta). Servir con tomates.',
  'Olivenöl in der Pfanne erhitzen und die Baconstreifen von beiden Seiten knusprig anbraten. Bacon bei Seite legen und warm halten. Bei mittlerer Hitze je zwei Eier in die Pfanne schlagen, mit Salz und Pfeffer würzen und anbraten (nicht wenden). Mit Tomaten servieren.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '49457d2a-8a02-40de-9816-f1ac3c9ac5a9',
  'Tortilla rellena',
  'Gefülltes Omelett',
  'breakfast',
  293.0,
  31.9,
  15.5,
  4.4,
  '1 PORCIÓN',
  '1 PORTION',
  'Romper los huevos en un bol, añadir las claras de huevo y la sal y batir con un tenedor. Calentar la mantequilla en una sartén y distribuir la mezcla de huevos uniformemente en la sartén. Dejar cuajar a fuego lento durante 2-3 minutos, luego dejar cuajar tapado durante 5-8 minutos. Mientras tanto, calentar la mantequilla para las verduras en otra sartén. Cortar los champiñones y el tomate en trozos pequeños y añadirlos a la sartén. Sazonar con sal y pimienta. Sofreír durante unos 5-8 minutos. Colocar la tortilla en un plato, distribuir las verduras por encima y doblar la tortilla por ambos lados.',
  'Eier in eine Schüssel aufschlagen, Eiklar und Salz dazugeben und mit einer Gabel verquirlen. Butter in einer Pfanne erhitzen und die Eimasse gleichmäßig in der Pfanne verteilen. Bei schwacher Hitze 2-3 Minuten stocken lassen, dann zugedeckt 5-8 Minuten stocken lassen. In der Zwischenzeit in einer anderen Pfanne die Butter für das Gemüse erhitzen. Champignons und Tomate klein schneiden und in die Pfanne geben. Mit Salz und Pfeffer würzen. Etwa 5-8 Minuten anbraten. Omelett auf einen Teller legen, Gemüse darüber verteilen und Omelett von beiden Seiten zuklappen.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  'c0114175-58db-440b-a0c7-bae55af67582',
  'Bowl de Desayuno',
  'Frühstücks Bowl',
  'breakfast',
  295.0,
  16.3,
  13.9,
  12.2,
  '1 PORCIÓN',
  '1 PORTION',
  'Poner el yogur y la mitad de los arándanos en un bol y triturar con una batidora de mano. Exprimir el limón, añadir el zumo y mezclar. Poner el yogur en un bol y distribuir las bayas de goji, los arándanos, las almendras y las semillas de chía sobre el yogur.',
  'Joghurt und die Hälfte der Blaubeeren in eine Schüssel geben und mit einem Stabmixer pürieren. Zitrone auspressen, den Saft dazugeben und verrühren. Joghurt in eine Schüssel geben und Goji Beeren, Blaubeeren, Mandeln und Chia Samen über dem Joghurt verteilen.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '2d1ca448-ac09-44b4-8ce6-0f9374718dc1',
  'Huevos revueltos con verduras',
  'Rührei mit Gemüse',
  'breakfast',
  297.0,
  29.7,
  14.1,
  0,
  '1 PORCIÓN',
  '1 PORTION',
  'Romper los huevos en un bol, añadir las claras y la sal y batir con un tenedor. Lavar los pimientos, retirar las semillas y cortarlos en trozos pequeños. Derretir la mantequilla en una sartén a fuego medio, añadir la mezcla de huevos y los pimientos a la sartén. Con una espátula/cuchara de cocina, ir empujando los huevos revueltos desde el borde de la sartén hacia el centro. Los huevos revueltos están listos cuando estén completamente cuajados. Cortar el tomate en cuartos y servir con los huevos revueltos.',
  'Eier in eine Schüssel aufschlagen, Eiklar und Salz dazu geben und mit einer Gabel verquirlen. Paprika waschen, Kerngehäuse entfernen und klein schneiden. Butter in einer Pfanne auf mittlerer Hitze schmelzen, Eimasse und Paprika in die Pfanne hineingeben. Mit einem Spatel/Kochlöffel vom Pfannenrand das Rührei immer wieder die Mitte schieben. Das Rührei ist fertig, wenn es komplett gestockt ist. Tomate vierteln und mit Rührei servieren.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  'ff58d9b9-fa8b-443b-9e0e-b500de9a77ec',
  'Kickstarter Bowl',
  'Kickstarter Bowl',
  'breakfast',
  259.0,
  14.2,
  12.7,
  0,
  '1 PORCIÓN',
  '1 PORTION',
  'Triturar finamente el yogur, las frambuesas y los arándanos con una batidora de mano. Reservar algunos frutos para el topping. Exprimir el limón, añadir el zumo de limón a la mezcla de yogur y remover. Poner la mezcla de yogur en un bol y cubrir con los frutos restantes. Distribuir el coco rallado y las semillas de chía sobre el yogur.',
  'Joghurt, Himbeeren, Blaubeeren mit einem Stabmixer fein pürieren. Ein paar Beeren für das Topping zur Seite legen. Zitrone auspressen, Zitronensaft zur Joghurt Mischung geben und verrühren. Joghurtmischung in eine Schüssel geben und mit den übrigen Beeren bedecken. Kokosraspeln und Chia Samen über dem Joghurt verteilen.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '34c1fce1-bfc4-4501-9973-6051a87f6875',
  'Muffins de huevos revueltos',
  'Rührei Muffins',
  'breakfast',
  313.0,
  27.8,
  16.2,
  0,
  '4 MUFFINS',
  '4 MUFFINS',
  'Precalentar el horno a 200 grados (calor arriba/abajo). Romper los huevos en un bol, añadir las claras, sazonar con sal y batir con un tenedor. Cortar las cebolletas en trozos pequeños. Añadir las cebolletas, el queso y la leche y mezclar. Distribuir la masa en moldes para muffins (4 muffins) y hornear durante 14-16 minutos.',
  'Backofen auf 200 Grad (Ober-/Unterhitze) vorheizen. Eier in eine Schüssel schlagen, Eiklar dazugeben, mit Salz würzen und mit einer Gabel verquirlen. Frühlingszwiebeln klein schneiden. Frühlingszwiebeln, Käse und Milch dazugeben und unterrühren. Masse in Muffinformen (4 Muffins) verteilen und 14-16 Minuten backen.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '81d91094-afd1-4afd-b0eb-1133464af868',
  'Gofres bajos en carbohidratos de almendra',
  'Mandel Low Carb Waffeln',
  'breakfast',
  326.0,
  34.4,
  17.1,
  6.5,
  '1 PORCIÓN',
  '1 PORTION',
  'Poner la harina de almendras y los huevos en un bol y mezclar. Añadir la leche de almendras, la levadura en polvo y el aroma de vainilla y remover. Engrasar una gofrera con un poco de aceite o mantequilla. Verter la masa en la gofrera y hornear durante aproximadamente 2-3 minutos hasta que los gofres estén dorados. Servir los gofres con varias bayas.',
  'Mandelmehl und Eier in eine Schüssel geben und vermischen. Mandelmilch, Backpulver und Vanillearoma dazugeben und verrühren. Ein Waffeleisen mit etwas Öl oder Butter einfetten. Teig in das Waffeleisen hineingeben und ca. 2-3 Minuten backen bis die Waffeln goldbraun sind. Waffeln mit verschiedenen Beeren servieren.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '28550c68-dcb8-46c2-a18f-d2aa3dd424f7',
  'Pancakes Low Carb',
  'Low Carb Pancakes',
  'breakfast',
  327.0,
  28.4,
  18.4,
  9.9,
  '1 PORCIÓN',
  '1 PORTION',
  'Poner la harina de almendras, el huevo y la leche en un bol y mezclar con una batidora de mano. Añadir el aceite de coco, la levadura en polvo y la sal y remover. Dejar reposar la masa 10 minutos. Derretir un poco de mantequilla en una sartén a fuego medio. Luego verter un poco de masa (según el tamaño del pancake) en la sartén. En cuanto se formen pequeñas burbujas (después de aproximadamente 2-3 minutos) en la parte superior del pancake, darle la vuelta y freír un minuto más. Servir los pancakes con bayas frescas. También se pueden utilizar otras bayas.',
  'Mandelmehl, Ei und Milch in eine Schüssel geben und mit einem Handmixer vermischen. Kokosöl, Backpulver und Salz dazugeben und verrühren. Teig 10 Minuten ruhen lassen. Etwas Butter in einer Pfanne bei mittlerer Hitze schmelzen. Dann etwas Teig (je nach Größe vom Pancake) in die Pfanne gießen. Sobald sich leichte Bläschen (nach ca. 2-3 Minuten) auf der Oberseite vom Pancake bilden, wenden und eine weitere Minute braten. Pancakes mit frischen Beeren servieren. Sie können auch andere Beeren verwenden.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '145098a0-71eb-43ed-ab18-8f5f072ccd0d',
  'Tortilla con bacon y tomates',
  'Omelett mit Speck und Tomaten',
  'breakfast',
  334.0,
  28.9,
  19.4,
  6.5,
  '1 TORTILLA',
  '1 OMELETT',
  'Cascar el huevo en un bol, añadir las claras y batir con un tenedor. Salpimentar. Lavar el tomate y cortarlo en rodajas. Lavar la cebolleta y cortarla en aros finos. Freír la loncha de bacon en una sartén (sin grasa ni mantequilla) hasta que esté crujiente y dejar escurrir sobre papel de cocina. Calentar la mantequilla en la sartén y verter la mezcla de huevos. Tapar y dejar cuajar brevemente, luego distribuir por encima el bacon, los tomates y la crème fraîche. Doblar y dejar cuajar tapado. Servir la tortilla con cebolletas.',
  'Ei in eine Schüssel schlagen, Eiklar dazugeben und mit einer Gabel verquirlen. Mit Salz und Pfeffer würzen. Tomate waschen und in Scheiben schneiden. Frühlingszwiebel waschen und in dünne Ringe schneiden. Speckscheibe in einer Pfanne (ohne Fett oder Butter) knusprig anbraten und auf ein Küchenpapier abtropfen lassen. Butter in der Pfanne erhitzen und die Eimischung in die Pfanne gießen. Zugedeckt kurz stocken lassen, dann Speck, Tomaten und Crème fraîche darüber verteilen. Zusammenklappen und zugedeckt stocken lassen. Omelett mit Frühlingszwiebeln servieren.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '1a02a9cd-beaf-4753-8a79-bf55901a5f56',
  'Pancakes de arándanos',
  'Blaubeer Pancakes',
  'breakfast',
  335.0,
  33.5,
  16.2,
  11.7,
  '1 PORCIÓN',
  '1 PORTION',
  'Poner la harina de almendra, la leche y la levadura en un bol y mezclar con una batidora de mano. Añadir el huevo, la clara y la sal y mezclar. Calentar la mantequilla en una sartén, verter un poco de masa (según el tamaño de los pancakes) en la sartén y distribuir algunos arándanos sobre la masa blanda. Tapar la sartén y dejar cocinar a fuego lento durante 2-3 minutos. Dar la vuelta al pancake y freír tapado por el otro lado durante 1-2 minutos más. Freír más pancakes hasta que se agote toda la masa. Espolvorear opcionalmente los pancakes con azúcar glas Xucker. Si no tiene arándanos, también puede usar otras bayas para los pancakes.',
  'Mandelmehl, Milch und Backpulver in eine Schüssel geben und mit einem Handrührgerät vermischen. Ei, Eiklar und Salz dazugeben und verrühren. Butter in einer Pfanne erhitzen, etwas Teig (je nach Größe der Pancakes) in die Pfanne geben und auf dem weichen Teig einige Blaubeeren verteilen. Pfanne mit einem Deckel zudecken und 2-3 Minuten bei leichter Hitze ziehen lassen. Pancake wenden und von der anderen Seite weitere 1-2 Minuten zugedeckt braten. Weitere Pancakes braten, bis der komplette Teig aufgebraucht ist. Pancakes optional mit Puder-Xucker bestreuen. Wenn Sie keine Blaubeeren haben, können Sie auch andere Beeren für die Pancakes nehmen.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '4c0c70ed-f329-4fbe-ab5a-02ac44f7c00d',
  'Pan plano mini',
  'Mini Fladenbrot',
  'breakfast',
  336.0,
  29.5,
  22.0,
  2.6,
  '1 PAN PLANO',
  '1 FLADENBROT',
  'Precalentar el horno a 150 grados (aire circulante). Separar los huevos y batir las claras junto con las claras adicionales y la pizca de sal hasta obtener punto de nieve. Mezclar las yemas junto con el queso crema, la levadura en polvo y la sal con una batidora de mano. Incorporar las claras batidas a punto de nieve en la mezcla. Cubrir una bandeja de horno con papel de hornear. Verter la mezcla sobre la bandeja formando un pan plano. Hornear durante 20-25 minutos.',
  'Backofen auf 150 Grad (Umluft) vorheizen. Eier trennen und das Eiklar mit dem zusätzlichen Eiklar und der Prise Salz steif schlagen. Eigelbe zusammen mit Frischkäse, Backpulver und Salz mit einem Handrührgerät vermischen. Steif geschlagenes Eiklar unter die Masse heben. Ein Backblech mit Backpapier auslegen. Die Masse auf das Backblech zu einem Fladenbrot gießen. Für 20-25 Minuten backen.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '7297ee6c-d839-4065-bca8-8eb8dd45cb93',
  'Frittata de tomates',
  'Tomaten Frittata',
  'breakfast',
  336.0,
  24.4,
  21.2,
  9.4,
  '1 PORCIÓN',
  '1 PORTION',
  'Batir el huevo en un bol, agregar las claras y mezclar con un tenedor. Sazonar con sal y pimienta. Cortar la cebolleta en trozos pequeños e incorporar a la mezcla de huevo. Verter el aceite de oliva en una sartén a fuego bajo, añadir la mezcla de huevo y freír durante 2-3 minutos. Lavar los tomates, cortarlos por la mitad y distribuirlos sobre la mezcla. Tapar y dejar cuajar durante 6-8 minutos.',
  'Ei in eine Schüssel schlagen, Eiweiß dazugeben und mit einer Gabel verquirlen. Mit Salz und Pfeffer würzen. Frühlingszwiebel klein schneiden und unter die Eimischung unterrühren. Olivenöl in eine Pfanne bei geringer Hitze geben, Eimischung hineingießen und 2-3 Minuten anbraten. Tomaten waschen, halbieren und auf der Masse verteilen. Zugedeckt 6-8 Minuten stocken lassen.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  'c2733446-f02c-4770-be11-4e7b97c381db',
  'Tortilla con verduras',
  'Omelette mit Gemüse',
  'breakfast',
  345.0,
  24.0,
  21.6,
  0,
  '1 PORCIÓN',
  '1 PORTION',
  'Batir los huevos y las claras en un bol y mezclar con un tenedor. Salpimentar. Calentar la mantequilla en una sartén y verter la mezcla de huevos. Tapar la sartén y dejar cuajar 4-6 minutos a fuego suave. Lavar las verduras y cortarlas en trozos pequeños. Calentar el aceite de oliva en una sartén y sofreír las verduras (excepto las aceitunas) 5-10 minutos a fuego lento. Salpimentar. Distribuir las verduras y las aceitunas sobre la tortilla, cubrir con rúcula y doblar.',
  'Eier und Eiweiß in eine Schüssel schlagen und mit einer Gabel verquirlen. Mit Salz und Pfeffer würzen. Butter in einer Pfanne erhitzen und die Eiermasse in die Pfanne geben. Pfanne zudecken und 4-6 Minuten bei milder Hitze stocken lassen. Das Gemüse waschen und klein schneiden. Olivenöl in einer Pfanne erhitzen und das Gemüse (außer die Oliven) 5-10 Minuten bei schwacher Hitze anbraten. Mit Salz und Pfeffer würzen. Gemüse und Oliven auf das Omelette verteilen, mit Rucola belegen und zuklappen.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '42949dca-5609-42b9-928a-50e482fc71a0',
  'Tortilla rellena de verduras',
  'Gefülltes Omelett mit Gemüse',
  'breakfast',
  350.0,
  24.6,
  18.1,
  0,
  '1 PORCIÓN',
  '1 PORTION',
  'Poner los huevos, las claras, la leche y la sal en un bol y batir. Para el relleno, pelar la cebolla y cortarla en trozos pequeños. Limpiar el pimiento y los tomates, secarlos y cortarlos en trozos pequeños. Limpiar las judías verdes y cortarlas en trozos pequeños si fuera necesario. Cocer las judías al vapor en agua ligeramente salada durante 10-15 minutos. Escurrir y dejar escurrir bien. Calentar un poco de mantequilla en una sartén, verter la mezcla de huevos y dejar que se extienda por el fondo de la sartén. Dejar cuajar la tortilla tapada durante 6-8 minutos. Cubrir la tortilla con las verduras, salpimentar, rociar con aceite de oliva y doblar.',
  'Eier, Eiklar, Milch und Salz in eine Schüssel geben und verquirlen. Für die Füllung Zwiebel schälen und klein schneiden. Paprika und Tomaten putzen, trocken tupfen und klein schneiden. Grüne Bohnen putzen und falls nötig klein schneiden. Bohnen in leicht gesalzenem Wasser 10-15 Minuten dünsten. Abgießen und abtropfen lassen. Etwas Butter in einer Pfanne erhitzen und die Eimasse hineingießen und auf dem Pfannenboden verlaufen lassen. Omelett zugedeckt 6-8 Minuten stocken lassen. Omelett mit Gemüse belegen, mit Salz und Pfeffer würzen, mit Olivenöl beträufeln und zuklappen.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  'bcc17229-94cd-451e-8db5-1beafa02c49f',
  'Torre de Pancakes',
  'Pancake Turm',
  'breakfast',
  350.0,
  39.6,
  18.2,
  4.6,
  '1 PORCIÓN',
  '1 PORTION',
  'En el primer paso se preparan los pancakes. Para ello, poner el quark desnatado, los huevos, la proteína en polvo y la leche en un bol y mezclar. Si la masa está demasiado espesa, añadir más leche. Calentar la mantequilla en una sartén. Verter aproximadamente 1/4 de la masa en la sartén, en cuanto aparezcan pequeñas burbujas en la parte superior, dar la vuelta al pancake y dorar. Repetir el proceso hasta que se acabe toda la masa. Para la crema, mezclar el quark desnatado, el agua mineral, el edulcorante y el zumo de limón. Colocar el pancake en un plato y untar con la crema. Repetir el proceso hasta que se acaben los pancakes y la crema.',
  'Im ersten Schritt werden die Pancakes zubereitet. Hierfür Magerquark, Eier, Proteinpulver und Milch in eine Schüssel geben und verrühren. Sollte der Teig zu dickflüssig sein, mehr Milch dazugeben. Butter in einer Pfanne erhitzen. Etwa 1/4 vom Teig in die Pfanne geben, sobald auf der oberen Seite kleine Bläschen entstehen, Pancake wenden und goldig ausbacken. Vorgang wiederholen bis der ganze Teig aufgebraucht ist. Für die Creme Magerquark, Mineralwasser, Süßstoff und Zitronensaft vermischen. Pancake auf einen Teller legen und mit der Creme bestreichen. Vorgang wiederholen, bis Pancakes und Creme aufgebraucht sind.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  'f1f9d9c2-8b20-4bd7-ae71-f5950adcb3dd',
  'Gofres de harina de almendra y quark',
  'Mandelmehl Quark Waffeln',
  'breakfast',
  358.0,
  33.3,
  21.7,
  4.9,
  '1 PORCIÓN',
  '1 PORTION',
  'Poner la harina de almendra, el quark y la leche en un bol y mezclar. Añadir los huevos, la clara de huevo, la proteína en polvo, la levadura en polvo y el aceite de coco y mezclar con una batidora de mano. Precalentar una gofrera y hornear los gofres con la masa. Servir los gofres con diferentes bayas y mermelada baja en carbohidratos.',
  'Mandelmehl, Quark und Milch in eine Schüssel geben und vermischen. Eier, Eiweiß, Proteinpulver, Backpulver und Kokosöl dazugeben und mit einem Handrührgerät vermischen. Ein Waffeleisen vorheizen und aus dem Teig Waffeln ausbacken. Waffeln mit verschiedenen Beeren und Low Carb Marmelade servieren.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  'c6d5b02a-da6b-44bf-b594-c0383422aab7',
  'Protein Pancakes con arándanos',
  'Protein Pancakes mit Blaubeeren',
  'breakfast',
  366.0,
  34.9,
  15.5,
  19.2,
  '1 PORCIÓN',
  '1 PORTION',
  'Poner la leche, el huevo, las claras de huevo y la harina de almendras en un bol y mezclar con una batidora de mano. Añadir la proteína en polvo, la levadura, la sal y el edulcorante y mezclar. Incorporar los arándanos a la masa. Calentar la mantequilla en una sartén y verter un poco de masa en la sartén (varía según el tamaño del pancake). En cuanto el lado superior empiece a formar burbujas, dar la vuelta al pancake y dorarlo hasta que quede dorado. Para la salsa de arándanos, triturar los arándanos con una batidora de mano. Mezclar los arándanos con el yogur e incorporar el zumo de limón. Servir los pancakes con la salsa de arándanos.',
  'Milch, Ei, Eiklar und Mandelmehl in eine Schüssel geben und mit einem Handrührgerät vermischen. Proteinpulver, Backpulver, Salz und Süßstoff dazugeben und verrühren. Blaubeeren unter den Teig heben. Butter in einer Pfanne erhitzen und etwas Teig in die Pfanne geben (variiert je nach Größe des Pancakes). Sobald die obere Seite anfängt Bläschen zu bilden, Pancake wenden und goldbraun ausbacken Für die Blaubeersoße die Blaubeeren mit einem Pürierstab pürieren. Blaubeeren mit Joghurt vermischen und Zitronensaft unterrühren. Pancakes mit Blaubeersoße servieren.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '13651bdc-23b3-462f-9c17-2e67546881cf',
  'Tortitas con frambuesas calientes',
  'Pfannkuchen mit heißen Himbeeren',
  'breakfast',
  376.0,
  27.9,
  24.8,
  7.2,
  '1 PORCIÓN',
  '1 PORTION',
  'Poner la harina de almendras, el huevo y la leche en un bol y mezclar con una batidora de mano. Añadir el aceite de coco, la levadura en polvo y la sal y mezclar hasta obtener una masa homogénea. Si la masa está demasiado espesa, añadir un poco más de leche. Derretir un poco de mantequilla en una sartén a fuego medio. Verter la mitad de la masa en la sartén, cuando la masa empiece a formar burbujas, dar la vuelta con cuidado al crepe y dorar. Repetir este proceso con el resto de la masa. La masa alcanza para dos crepes. Poner las frambuesas en un cazo y calentar a fuego medio. Exprimir el limón y añadir el zumo a las frambuesas y mezclar. Untar los crepes con las frambuesas calientes y doblarlos.',
  'Mandelmehl, Ei und Milch in eine Schüssel geben und mit einem Handrührgerät vermischen. Kokosöl, Backpulver und Salz dazugeben und zu einem gleichmäßigen Teig verrühren. Sollte der Teig zu dickflüssig sein, etwas mehr Milch dazugeben. Etwas Butter in einer Pfanne bei mittlerer Hitze schmelzen. Die Hälfte vom Teig in die Pfanne geben, wenn der Teig anfängt Bläschen zu bilden, Pfannkuchen vorsichtig wenden und goldbraun ausbacken. Diesen Vorgang mit dem restlichen Teig wiederholen. Der Teig reicht für zwei Pfannkuchen. Himbeeren in einen Topf geben und bei mittlerer Hitze erhitzen. Zitrone auspressen und den Saft zu den Himbeeren geben und verrühren. Pfannkuchen mit heißen Himbeeren bestreichen und zuklappen.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  'f5e50e91-33d0-428c-8455-3fd389d26153',
  'Pancakes de Harina de Almendras',
  'Mandelmehl Pancakes',
  'breakfast',
  393.0,
  39.0,
  22.9,
  5.0,
  '1 PORCIÓN',
  '1 PORTION',
  'Separar el huevo y montar las claras a punto de nieve junto con las claras adicionales. Mezclar la yema, la harina de almendras, la levadura en polvo y la leche en un bol. Incorporar las claras montadas a la masa. Calentar el aceite en una sartén y verter dos cucharadas de masa en la sartén. En cuanto la parte superior forme burbujas, dar la vuelta al pancake. Repetir el proceso hasta que se acabe toda la masa. Servir los pancakes con fruta fresca.',
  'Ei trennen und das Eiklar zusammen mit dem zusätzlichen Eiklar steif schlagen. Eigelb, Mandelmehl, Backpulver und die Milch in einer Schüssel verrühren. Eischnee unter den Teig heben. Öl in einer Pfanne erhitzen und zwei Esslöffel vom Teig in die Pfanne geben. Sobald die obere Seite Bläschen wirft, Pancake wenden. Den Vorgang wiederholen, bis der ganze Teig aufgebraucht ist. Pancakes mit frischem Obst servieren.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  'b2d68271-2e92-4499-ae23-92ca8390e873',
  'Frittata de Verduras',
  'Gemüse Frittata',
  'breakfast',
  459.0,
  24.9,
  33.0,
  12.4,
  '1 PORCIÓN',
  '1 PORTION',
  'Precalentar el horno a 160 grados (aire caliente). Lavar el pimiento, el calabacín y los champiñones y cortarlos en cubos. Picar finamente el ajo y la cebolla. Cortar las aceitunas en rodajas. Calentar el aceite de oliva en una sartén y sofreír la cebolla y el ajo. Añadir las verduras y saltear brevemente. Batir los huevos y las claras en un bol, sazonar con sal y pimienta y batir bien. Cubrir una fuente de horno con papel de hornear y añadir las verduras. Verter la mezcla de huevos, mezclar un poco y hornear durante 10-15 minutos. Servir con perejil fresco.',
  'Backofen auf 160 Grad (Umluft) vorheizen. Paprika, Zucchini und Champignons waschen und in Würfel schneiden. Knoblauch und Zwiebel klein hacken. Oliven in Scheiben schneiden. Olivenöl in einer Pfanne erhitzen und darin Zwiebeln und Knoblauch andünsten. Gemüse dazugeben und kurz anbraten. Eier und Eiweiß in eine Schüssel schlagen, mit Salz und Pfeffer würzen und verquirlen. Eine Auflaufform/Backform mit Backpapier auslegen und das Gemüse hineingeben. Die Eiermasse hinzugießen, etwas vermischen und für 10-15 Minuten backen. Mit frischer Petersilie servieren.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  'b48ba79d-549b-470a-83c0-c56805385060',
  'Tortitas de apio con huevo frito',
  'Selleriepuffer mit Spiegelei',
  'breakfast',
  457.0,
  35.8,
  30.0,
  7.6,
  '1 PORCIÓN',
  '1 PORTION',
  'Pelar el apio y rallarlo o cortarlo en tiras finas. Mezclar las tiras de apio con el resto de los ingredientes (excepto la mantequilla) en un bol. Calentar la mantequilla en una sartén y freír dos tortitas con la mezcla. Colocar las tortitas sobre un paño de cocina. Para los huevos fritos, calentar el aceite de oliva en una sartén a fuego lento, cascar los huevos en la sartén. Sazonar con sal y pimienta y freír durante 3-4 minutos. Cubrir cada tortita con una loncha de jamón cocido y colocar encima los huevos fritos.',
  'Sellerie schälen und in dünne Streifen raspeln oder schneiden. Selleriestreifen mit den restlichen Zutaten (außer Butter) in einer Schüssel vermischen. Butter in einer Pfanne erhitzen und aus der Masse zwei Puffer braten. Puffer auf ein Küchentuch legen. Für die Spiegeleier das Olivenöl in einer Pfanne bei kleiner Hitze erhitzen, Eier in die Pfanne schlagen. Mit Salz und Pfeffer würzen und 3-4 Minuten braten. Puffer mit je einer Scheibe Kochschinken belegen und darüber die Spiegeleier legen.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '3c88f28a-8c81-440c-8fde-89f04c9740ad',
  'Brochetas de champiñones',
  'Champignons Spieße',
  'lunch',
  110.0,
  2.5,
  9.8,
  2.2,
  '4 PORCIONES',
  '4 PORTIONEN',
  'Limpiar los champiñones y retirar los tallos. Picar finamente la cebolla y los dientes de ajo y mezclar con aceite de oliva (5 cucharadas), vinagre balsámico, orégano, perejil, sal y pimienta. Añadir los champiñones y dejar marinar en el refrigerador durante 3-4 horas. Ensartar los champiñones en brochetas de madera. Calentar una cucharada de aceite de oliva en una sartén y dorar las brochetas de champiñones por todos los lados. Rociar los champiñones con jugo de limón fresco.',
  'Champignons putzen und Stängel entfernen. Zwiebel und Knoblauchzehen fein hacken und mi Olivenöl (5 Esslöffel), Balsamico-Essig, Oregano, Petersilie, Salz und Pfeffer vermischen. Champignons dazugeben und für 3-4 Stunden im Kühlschrank ziehen lassen. Champignons auf Holzspieße stecken. Einen Esslöffel Olivenöl in einer Pfanne erhitzen und die Champignon-Spieße von allen Seiten goldbraun anbraten. Champignons mit frischem Zitronensaft beträufeln.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  'cd763d4f-0fb4-4742-8f1a-3509ec6288ac',
  'Sartén de pimientos asados',
  'Gebratene Paprikapfanne',
  'lunch',
  156.0,
  2.2,
  11.4,
  9.2,
  '4 PORCIONES',
  '4 PORTIONEN',
  'Enjuagar los pimientos bajo agua fría, escurrir, retirar el tallo y las semillas y cortar en trozos alargados. Pelar los dientes de ajo y prensarlos. Calentar el aceite de oliva en una olla o sartén, añadir el ajo y sofreír durante 2-3 minutos. Añadir los pimientos y las alcaparras y remover. Sazonar con sal, pimienta y pimentón en polvo. Verter el agua, tapar y dejar estofar a fuego medio durante 10 minutos. Retirar la tapa y cocinar por 5 minutos más.',
  'Paprikaschoten unter kaltem Wasser abspülen, abtropfen lassen, Strunk und Kerngehäuse entfernen und in längliche Stücke schneiden. Knoblauchzehen schälen und klein pressen. Olivenöl in einem Topf oder einer Pfanne erhitzen Knoblauch dazu geben und 2-3 Minuten andünsten. Paprika und Kapern dazugeben und umrühren. Mit Salz, Pfeffer und Paprikapulver würzen. Wasser dazu gießen und zugedeckt 10 Minuten bei mittlerer Hitze schmoren lassen. Deckel entfernen und für weitere 5 Minuten kochen.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  'bd92450f-d2b7-4e32-a2e6-8edc8d9ed382',
  'Gratén de verduras',
  'Gemüsegratin',
  'lunch',
  168.0,
  4.5,
  11.8,
  9.3,
  '4 PORCIONES',
  '4 PORTIONEN',
  'Precalentar el horno a 180 grados (aire circulante). Lavar los calabacines, los tomates y las berenjenas y cortarlos en rodajas. Colocar las rodajas de verduras de forma alternada y en posición vertical en una fuente para hornear. Prensar finamente el diente de ajo con un prensador de ajos. Mezclar el aceite de oliva con el ajo y rociar las verduras con la mezcla. Sazonar con sal y pimienta. Hornear durante 12-14 minutos. Decorar con romero y tomillo.',
  'Backofen auf 180 Grad (Umluft) vorheizen. Zucchini, Tomaten und Auberginen waschen und in Scheiben schneiden. Die Gemüsescheiben abwechselnd und aufrecht in eine Auflaufform legen. Knoblauchzehe mit einer Knoblauchpresse fein pressen. Olivenöl mit Knoblauch vermischen und das Gemüse damit beträufeln. Mit Salz und Pfeffer würzen. Für 12-14 Minuten backen. Mit Rosmarin und Thymian dekorieren.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  'c54d5491-0f65-455e-bae8-7c6fbff1df97',
  'Berenjenas rellenas con verduras',
  'Gefüllte Auberginen mit Gemüse',
  'lunch',
  172.0,
  6.2,
  8.1,
  17.1,
  '4 PORCIONES',
  '4 PORTIONEN',
  'Precalentar el horno a 180 grados (aire circulante). Lavar las berenjenas, cortarlas por la mitad a lo largo y sacar la pulpa con una cuchara. No tirar la pulpa. (Se utilizará para el relleno). Cortar la cebolla en trozos pequeños y prensar el ajo finamente. Calentar el aceite de oliva en una sartén y rehogar brevemente la cebolla y el ajo. Lavar los tomates y los pimientos, cortarlos en trozos pequeños y añadirlos a la sartén. Sofreír durante aproximadamente 5 minutos. Colocar las berenjenas una al lado de la otra en una bandeja para hornear (con papel de horno). Rellenar las berenjenas con la mezcla de verduras y hornear durante 25-30 minutos. Servir con perejil fresco.',
  'Backofen auf 180 Grad (Umluft) vorheizen. Auberginen waschen, längs halbieren und das Fruchtfleisch mit einem Löffel herauslöffeln. Das Fruchtfleisch nicht wegschmeißen. (Es wird für die Füllung verwendet). Zwiebel klein schneiden und Knoblauch klein pressen. Olivenöl in einer Pfanne erhitzen und darin Zwiebeln und Knoblauch kurz andünsten. Tomaten und Paprika waschen, in kleine Stücke schneiden und in die Pfanne geben. Circa 5 Minuten anbraten. Auberginen nebeneinander auf ein Backblech (mit Backpapier) legen. Auberginen mit der Gemüsemischung füllen und für 25-30 Minuten backen. Mit frischer Petersilie servieren.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '2ca7654c-1802-4efe-a9ef-f16f65a9d33c',
  'Ratatouille de verduras',
  'Gemüse Ratatouille',
  'lunch',
  205.0,
  4.7,
  13.8,
  13.5,
  '4 PORCIONES',
  '4 PORTIONEN',
  'Pelar las cebollas y el ajo y picarlos finamente. Despepitar los pimientos, retirar el tallo y cortarlos en trozos pequeños. Cortar los extremos del calabacín y cortarlo en cubos. Cortar los tomates y la berenjena (retirar el tallo) en cubos. Calentar el aceite de oliva en una sartén y sofreír las cebollas y el ajo hasta que estén transparentes. Añadir los pimientos y sofreír 2-3 minutos más. Agregar el calabacín, la berenjena y los tomates y sofreír 3-4 minutos. Añadir el caldo de verduras y el concentrado de tomate a la sartén y dejar cocinar a fuego medio durante aproximadamente 10 minutos. Sazonar con sal y pimienta. Añadir las aceitunas y dejar cocinar 2 minutos más. Servir con perejil fresco.',
  'Zwiebeln und Knoblauch schälen und klein schneiden. Paprika entkernen, Strunk entfernen und klein schneiden. Die Enden der Zucchini abschneiden und in Würfel schneiden. Tomaten und Aubergine (Strunk entfernen) in Würfel schneiden. Olivenöl in einer Pfanne erhitzen und Zwiebeln und Knoblauch glasig andünsten. Paprika dazugeben und weitere 2-3 Minuten anbraten. Zucchini, Aubergine und Tomaten dazugeben und 3-4 Minuten anbraten. Gemüsebrühe und Tomatenmark in die Pfanne geben und auf mittlerer Stufe ca. 10 Minuten köcheln lassen. Mit Salz und Pfeffer würzen. Oliven dazugeben und weitere 2 Minuten köcheln lassen. Mit frischer Petersilie servieren.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '0a9c1c7b-23bf-4db0-bf33-f4c0862b75d2',
  'Pechuga de pollo con tomates',
  'Hähnchenbrust mit Tomaten',
  'lunch',
  219.0,
  30.1,
  7.5,
  6.0,
  '4 PORCIONES',
  '4 PORTIONEN',
  'Cortar la pechuga de pollo en trozos del tamaño de un bocado. Picar finamente las cebollas y el ajo. Calentar el aceite de oliva en una sartén, añadir las cebollas y el ajo y sofreír brevemente. Añadir los trozos de pechuga de pollo y dorar. Sazonar con sal y pimienta. Una vez que la carne esté bien cocida, añadir los tomates. Espolvorear con tomillo y sofreír 2-3 minutos. Servir con albahaca y rociar con zumo de limón fresco.',
  'Hähnchenbrust in mundgerechte Stücke schneiden. Zwiebeln und Knoblauch klein schneiden. Olivenöl in einer Pfanne erhitzen, Zwiebeln und Knoblauch dazugeben und kurz andünsten. Hähnchenbruststücke dazugeben und anbraten. Mit Salz und Pfeffer würzen. Sobald das Fleisch durch ist, Tomaten dazugeben. Mit Thymian bestreuen und 2-3 Minuten anbraten. Mit Basilikum servieren und mit frischem Zitronensaft beträufeln.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '302b35df-cc06-4ced-a788-84d58b4c8ace',
  'Coliflor crujiente al horno',
  'Knuspriger Ofen-Blumenkohl',
  'lunch',
  234.0,
  8.5,
  19.0,
  5.2,
  '4 PORCIONES',
  '4 PORTIONEN',
  'Precalentar el horno a 200 grados (calor arriba/abajo). Retirar las hojas y el tallo de la coliflor. Separar los ramilletes de coliflor y lavarlos. Prensar finamente el diente de ajo. Mezclar el ajo, el zumo de limón, el curry en polvo, la sal, la pimienta y el aceite de oliva. Distribuir los ramilletes de coliflor en una fuente para horno. Rociar la mezcla de aceite sobre los ramilletes y espolvorear con parmesano. Verter el agua en la fuente para horno. Hornear durante 30-40 minutos. Los tomates u otras verduras son una buena guarnición.',
  'Backofen auf 200 Grad (Ober-/Unterhitze) vorheizen. Die Blätter und den Stielansatz vom Blumenkohl entfernen. Blumenkohlröschen abtrennen und waschen. Knoblauchzehe fein pressen. Knoblauch, Zitronensaft, Currypulver, Salz, Pfeffer und Olivenöl vermischen. Blumenkohlröschen in einer Auflaufform verteilen. Olivenmischung über die Röschen träufeln und mit Parmesan bestreuen. Wasser in die Auflaufform gießen. 30-40 Minuten backen. Als Beilage eignen sich Tomaten oder anderes Gemüse.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '059cd289-8bef-4e78-9061-c60582f69ad1',
  'Tomates al horno',
  'Tomaten aus dem Backofen',
  'lunch',
  266.0,
  3.1,
  22.9,
  9.8,
  '4 PORCIONES',
  '4 PORTIONEN',
  'Precalentar el horno a 200 grados (calor arriba/abajo). Lavar los tomates, secarlos dando toquecitos y cortarlos por la mitad. Picar finamente los dientes de ajo. Poner el ajo, el aceite de oliva y el tomillo en un bol y mezclar. Poner los tomates en una fuente para horno y rociar con la mezcla de aceite de oliva. Espolvorear con sal y pimienta. Hornear durante 10-15 minutos.',
  'Backofen auf 200 Grad (Ober-/Unterhitze) vorheizen. Tomaten waschen, trocken tupfen und halbieren. Knoblauchzehen klein hacken. Knoblauch, Olivenöl und Thymian in eine Schüssel geben und vermischen. Tomaten in eine Auflaufform geben und mit der Olivenöl-Mischung beträufeln. Mit Salz und Pfeffer bestreuen. Für 10-15 Minuten backen.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  'ff952b86-05f0-4fa4-b4e4-5453493e4f35',
  'Filete de bacalao con mix de pimientos',
  'Dorschfilet mit Paprika-Mix',
  'lunch',
  272.0,
  29.8,
  11.36,
  9.0,
  '4 PORCIONES',
  '4 PORTIONEN',
  'Lavar el bacalao y secarlo con papel absorbente. Lavar los pimientos y retirar las semillas. Cortar los pimientos en cubos pequeños. Calentar la mantequilla y el aceite de oliva en una sartén y sofreír brevemente los cubos de pimiento. Retirar los pimientos y añadir el bacalao a la sartén. Sazonar con sal, pimienta y pimentón en polvo. Volver a añadir los cubos de pimiento a la sartén y sofreír junto con el bacalao durante 1-2 minutos más. Repartir el bacalao y los pimientos en cuatro platos y servir.',
  'Den Dorsch waschen und trockentupfen. Die Paprika waschen und das Kerngehäuse entfernen Die Paprika in kleine Würfel schneiden. Die Butter und das Olivenöl in einer Pfanne erhitzen und die Paprikawürfel darin kurz anbraten. Paprika herausnehmen und den Dorsch in die Pfanne geben. Mit Salz, Pfeffer und dem Paprikapulver würzen. Die Paprikawürfel zurück in die Pfanne geben und zusammen mit dem Dorsch für weitere 1-2 Minuten anbraten. Den Dorsch und die Paprika auf vier Teller verteilen und servieren.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  'c4a8890e-e30f-46e5-adfd-04c997086f2c',
  'Fideos de calabacín con gambas',
  'Zucchininudeln mit Garnelen',
  'lunch',
  301.0,
  30.4,
  14.2,
  10.7,
  '4 PORCIONES',
  '4 PORTIONEN',
  'Colocar las gambas en un colador y dejar descongelar durante aproximadamente 1-2 horas. Pelar el ajo y picarlo finamente. Exprimir un limón y mezclar el ajo con el zumo de limón. Sazonar con sal y pimienta. Calentar el aceite de oliva en una sartén. Añadir las gambas descongeladas y sofreír brevemente. Verter la mezcla de zumo de limón y remover. Lavar los tomates y cortarlos en trozos pequeños. Añadir los tomates y el agua y dejar cocinar a fuego lento durante 3-5 minutos más. Lavar los calabacines y cortar los extremos. Con un espiralizador, cortar los calabacines en fideos finos. Opcionalmente, los calabacines también se pueden rallar finamente. Añadir los fideos de calabacín, remover y sofreír durante 2-3 minutos. Servir los fideos de calabacín y rociar con el zumo de limón restante.',
  'Garnelen in ein Sieb geben und ca. 1-2 Stunden auftauen lassen. Knoblauch schälen und klein hacken. Eine Zitrone auspressen und den Knoblauch mit dem Zitronensaft vermischen. Mit Salz und Pfeffer würzen. Olivenöl in einer Pfanne erhitzen. Aufgetaute Garnelen in die Pfanne geben und kurz anbraten Zitronensaftmischung dazu gießen und verrühren. Tomaten waschen und klein schneiden. Tomaten und Wasser dazugeben und weitere 3-5 Minuten auf geringer Hitze köcheln lassen. Zucchini waschen und die Enden abschneiden. Mit einem Spiralschneider aus den Zucchini dünne Nudeln schneiden. Optional können die Zucchini auch klein geraspelt werden. Zucchininudeln dazugeben, verrühren und 2-3 Minuten anbraten. Zucchininudeln servieren und mit dem restlichen Zitronensaft beträufeln.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '37f9f6ec-c7c3-455f-b164-d7cee9cd78b6',
  'Zoodles con tomates secos',
  'Zoodles mit getrockneten Tomaten',
  'lunch',
  302.0,
  9.8,
  21.5,
  11.0,
  '4 PORCIONES',
  '4 PORTIONEN',
  'Lavar los calabacines, cortar los extremos y rallarlos en forma de fideos con un cortador en espiral. Si no tiene un cortador en espiral, también puede cortar los calabacines en tiras largas con una mandolina de cocina. Cocer los fideos de calabacín en una olla con agua hirviendo con sal durante 2-3 minutos. Escurrir en un colador. Partir los tomates secos por la mitad y mezclarlos en un bol con sal, pimienta y aceite de oliva. Añadir los fideos de calabacín, la mezcla de hierbas y el zumo de limón y remover. Servir con queso rallado.',
  'Zucchini waschen, Enden abschneiden und mit einem Spiralschneider zu Nudeln raspeln. Sollten Sie keinen Spiralschneider haben, können Sie die Zucchini auch mit einem Küchenhobe in lange Streifen schneiden. Zucchininudeln in einem Topf mit kochendem Salzwasser für 2-3 Minuten garen. In einem Sieb abtropfen lassen. Getrocknete Tomaten halbieren und mit Salz, Pfeffer und Olivenöl in einer Schüssel vermischen. Zucchininudeln, Kräutermischung und Zitronensaft dazugeben und verrühren. Mit geriebenem Käse servieren.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  'b8d07be9-f11e-45d5-a8a4-32da34de9c65',
  'Ensalada de pechuga de pollo',
  'Hähnchenbrust-Salat',
  'lunch',
  305.0,
  30.0,
  16.5,
  7.1,
  '4 PORCIONES',
  '4 PORTIONEN',
  'Cortar la pechuga de pollo en tiras. Calentar aceite de oliva en una sartén, añadir las tiras de pechuga de pollo y sofreír. Sazonar con sal y pimienta. Limpiar y desmenuzar la lechuga y los canónigos. Poner la ensalada y las tiras de pechuga de pollo en un bol grande y mezclar. Cortar en trozos pequeños el tomate, el pepino, el feta y la cebolla y añadirlos. Mezclar el aceite de oliva, el vinagre, el zumo de limón, la sal y la pimienta y rociar la ensalada con este aliño.',
  'Hähnchenbrust in Streifen schneiden. Olivenöl in einer Pfanne erhitzen, Hähnchenbruststreifen dazugeben und anbraten. Mit Salz und Pfeffer würzen. Kopf- und Feldsalat putzen und zerpflücken. Salat und Hähnchenbruststreifen in eine große Schüssel geben und vermischen. Tomate, Salatgurke, Feta und Zwiebel klein schneiden und dazugeben. Olivenöl, Essig, Zitronensaft, Salz und Pfeffer vermischen und den Salat mit diesem Dressing beträufeln.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '5fb7a249-04dc-4f75-9a8c-63afac1f1910',
  'Filete de salmón con judías verdes',
  'Lachsfilet mit grünen Bohnen',
  'lunch',
  323.0,
  33.6,
  14.0,
  13.1,
  '4 PORCIONES',
  '4 PORTIONEN',
  'Pelar las zanahorias y cortarlas por la mitad a lo largo. Lavar las judías verdes y cocinarlas en agua hirviendo durante aprox. 10-12 minutos. En los últimos 4 minutos, añadir las zanahorias y cocinar junto con las judías. Escurrir en un colador. Cortar el salmón en trozos grandes, salpimentar y calentar la mantequilla en una sartén. Dorar el salmón a fuego alto por ambos lados durante 2-3 minutos. Servir el salmón con las judías/zanahorias y rociar con zumo de limón fresco.',
  'Karotten schälen und längst halbieren. Grüne Bohnen waschen und in kochendem Wasser ca. 10-12 Minuten garen. In den letzten 4 Minuten die Karotten dazugeben und mitgaren. In einem Sieb abgießen. Lachs in grobe Stücke schneiden, mit Salz und Pfeffer würzen und die Butter in einer Pfanne erhitzen. Lachs bei hoher Hitze von beiden Seiten 2-3 Minuten anbraten. Lachs mit den Erbsen/Karotten servieren und mit frischem Zitronensaft beträufeln.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '67d7608a-33fd-4039-8d01-c042f4247796',
  'Sopa de carne picada y verduras',
  'Hackfleisch-Gemüse-Suppe',
  'lunch',
  326.0,
  23.4,
  18.3,
  14.8,
  '4 PORCIONES',
  '4 PORTIONEN',
  'Cortar las cebollas en trozos pequeños. Calentar el aceite de oliva en una olla, sofreír brevemente la cebolla, añadir la carne picada y dorarla. Verter el caldo. Limpiar los pimientos, retirar el tallo y las semillas. Añadir los pimientos, los tomates troceados, las alubias y el concentrado de tomate a la olla y dejar cocer a fuego lento durante 15 minutos. Sazonar con sal, pimienta y pimentón. Añadir el maíz y dejar cocer a fuego lento otros 5-10 minutos.',
  'Zwiebeln klein schneiden. Olivenöl in einem Topf erhitzen, Zwiebel kurz andünsten, Hackfleisch dazugeben und anbraten. Mit der Brühe abgießen. Paprika putzen, dann Strunk und das Kerngehäuse entfernen. Paprika stückige Tomaten, Bohnen und Tomatenmark in den Topf geben und 15 Minuten köcheln lassen. Mit Salz, Pfeffer und Paprikapulver würzen. Mais dazugeben und weitere 5-10 Minuten köcheln lassen.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  'e9de456a-f716-4c0d-804f-1a2e03be182f',
  'Tortitas de calabacín',
  'Zucchini Bratlinge',
  'lunch',
  326.0,
  16.3,
  22.8,
  10.4,
  '4 PORCIONES',
  '4 PORTIONEN',
  'Lavar el calabacín, cortar los extremos y rallarlo finamente. Colocar los trozos de calabacín junto con el zumo de limón en un bol durante 30 minutos y dejar reposar. Después, envolver el calabacín en un paño de cocina y exprimir el agua con las manos. Cortar las zanahorias y las cebollas en tiras. Poner los huevos en un bol y batirlos con un tenedor. Añadir el calabacín, las zanahorias, la cebolla y el queso y mezclar. Sazonar con sal y pimienta. Calentar aceite en una sartén y formar porciones de la masa con las manos dándoles forma de hamburguesas, luego dorarlas por ambos lados en la sartén.',
  'Zucchini waschen, Enden abschneiden und klein raspeln. Zucchinistücke zusammen mit dem Zitronensaft für 30 Minuten in eine Schüssel legen und ziehen lassen. Danach die Zucchini in ein Küchentuch wickeln und mit den Händen das Wasser auspressen. Karotten und Zwiebeln in Streifen schneiden. Eier in eine Schüssel geben und mit einer Gabel verquirlen. Zucchini, Karotten, Zwiebel und Käse dazugeben und vermischen. Mit Salz und Pfeffer würzen. Öl in einer Pfanne erhitzen und mit den Händen portionsweise aus der Masse Bratlinge formen und in der Pfanne von beiden Seiten anbraten.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '94454096-6704-44cf-b13b-93fcb2fafda5',
  'Champiñones rellenos de espinacas',
  'Gefüllte Spinat Champignons',
  'lunch',
  328.0,
  5.9,
  29.6,
  6.7,
  '4 PORCIONES',
  '4 PORTIONEN',
  'Limpiar los champiñones, separar los tallos y cortarlos en trozos pequeños. Picar finamente el ajo y la cebolla. Calentar el aceite de oliva en una sartén y sofreír la cebolla con el ajo. Añadir los tallos de champiñón picados y sofreír durante 2-3 minutos. Agregar las espinacas, la nata y el queso y mezclar. Sazonar con sal y pimienta. Rellenar los sombreros de los champiñones con la mezcla de nata y distribuirlos en una bandeja de horno. Hornear en el horno precalentado a 200 grados (calor arriba/abajo) durante 10-15 minutos.',
  'Champignons putzen, Stiele heraustrennen und klein schneiden. Knoblauch und Zwiebel klein hacken. Olivenöl in einer Pfanne erhitzen und die Zwiebel mit dem Knoblauch andünsten. Die gehackten Pilzstiele dazugeben und 2-3 Minuten anbraten. Spinat, Sahne und Käse dazugeben und verrühren. Mit Salz und Pfeffer würzen. Champignonköpfe mit der Sahnemischung befüllen und auf ein Backblech verteilen. Im vorgeheizten Backofen bei 200 Grad (Ober-/Unterhitze) für 10-15 Minuten backen.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  'b92c26bb-5a07-464d-a0db-c3a1d263fbf1',
  'Gratén de coliflor',
  'Blumenkohl Auflauf',
  'lunch',
  330.0,
  24.3,
  20.5,
  9.7,
  '4 PORCIONES',
  '4 PORTIONEN',
  'Precalentar el horno a 180 grados (calor superior e inferior). Enjuagar la coliflor con agua fría y dividirla en ramilletes. Calentar la mantequilla en una sartén, añadir la coliflor y rehogar durante 3-5 minutos. Desglasar con el caldo de verduras. Batir los huevos, la leche, la sal y la pimienta en una olla y cocer a fuego lento durante 2-3 minutos. Distribuir la coliflor en una fuente para horno, verter encima la mezcla de huevo y espolvorear con queso. Remover y hornear durante 15-20 minutos.',
  'Backofen auf 180 Grad (Ober- und Unterhitze) vorheizen. Blumenkohl mit kaltem Wasser abspülen und in Röschen zerteilen. Butter in einer Pfanne erhitzen, Blumenkohl dazugeben und 3-5 Minuten andünsten. Mit Gemüsebrühe ablöschen. Eier, Milch, Salz und Pfeffer in einem Topf verquirlen und 2-3 Minuten köcheln. Blumenkohl in eine Auflaufform verteilen, mit der Eimasse übergießen und mit Käse bestreuen. Umrühren und für 15-20 Minuten backen.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  'aeefdb45-d852-4c7f-9f41-39fda8fd8b22',
  'Sopa cremosa de rebozuelos',
  'Cremige Pfifferlinge Suppe',
  'lunch',
  343.0,
  5.3,
  28.6,
  12.8,
  '4 PORCIONES',
  '4 PORTIONEN',
  'Pelar y picar finamente la cebolla y el ajo. Calentar el aceite de oliva y la mantequilla en una olla y rehogar la cebolla y el ajo. Limpiar los rebozuelos, partirlos por la mitad y añadirlos a la olla. Sofreír durante 2-3 minutos, luego desglasar con la nata y el caldo de verduras. Reducir el fuego, sazonar con sal y pimienta y dejar cocer a fuego lento durante 8-10 minutos. Triturar la sopa con una batidora de mano y servir.',
  'Zwiebel und Knoblauch schälen und klein hacken. Olivenöl und Butter in einem Topf erhitzen und darin Zwiebel und Knoblauch andünsten. Pfifferlinge putzen, halbieren und in den Topf geben. 2-3 Minuten anbraten, dann mit Sahne und Gemüsebrühe ablöschen. Hitze reduzieren, mit Salz und Pfeffer würzen und 8-10 Minuten köcheln lassen. Suppe mit einem Pürierstab klein pürieren und servieren.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  'cd80e277-e341-4103-b46f-510f9948fa60',
  'Rollito de calabacín relleno',
  'Gefüllte Zucchinirolle',
  'lunch',
  351.0,
  32.5,
  21.2,
  4.5,
  '4 PORCIONES',
  '4 PORTIONEN',
  'Separar los huevos, batir las claras a punto de nieve en un bol. Mezclar las yemas en otro bol con la harina de coco, la levadura, la menta, la sal y la pimienta. Picar finamente los dientes de ajo y añadirlos. Lavar el calabacín, cortar los extremos y rallarlo finamente. Añadir el calabacín a la mezcla de yemas y mezclar. Incorporar las claras a punto de nieve a la mezcla. Cubrir una bandeja de horno con papel de hornear y distribuir la masa uniformemente sobre la bandeja. Hornear durante 15 minutos. Dejar enfriar 5 minutos, luego cubrir con queso y jamón cocido y enrollar con cuidado. Hornear durante 3-5 minutos más.',
  'Eier trennen, Eiklar in einer Schüssel steif schlagen. Eigelbe in einer anderen Schüssel mit Kokosmehl, Backpulver, Minze, Salz und Pfeffer vermischen. Knoblauchzehen klein hacken und dazugeben. Zucchini waschen, Enden abschneiden und klein raspeln. Zucchini zur Eigelbmischung dazugeben und verrühren. Eiklar unter die Masse heben. Ein Backblech mit Backpapier auslegen und die Masse auf dem Backblech gleichmäßig verteilen. 15 Minuten backen. 5 Minuten abkühlen lassen, dann mit Käse und Kochschinken belegen und vorsichtig zusammenrollen. Für weitere 3-5 Minuten backen.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '1933b541-be07-4b70-95b4-2a831a387d5e',
  'Hamburguesas de Brócoli',
  'Brokkoli Bratlinge',
  'lunch',
  354.0,
  21.8,
  25.2,
  7.2,
  '4 PORCIONES',
  '4 PORTIONEN',
  'Limpiar el brócoli y cortarlo en trozos pequeños o picarlo finamente en una batidora (sin triturarlo demasiado). Rallar finamente los champiñones y la cebolla. Poner el brócoli, los champiñones, la cebolla, el queso y los huevos en un bol y mezclar. Añadir las cáscaras de psyllium, la harina de linaza, la sal, la pimienta y la mostaza y mezclar. Formar hamburguesas con la masa. Calentar el aceite de oliva en una sartén y freír las hamburguesas por ambos lados hasta que estén doradas.',
  'Brokkoli putzen und in kleine Stücke schneiden oder in einem Mixer klein hacken (nicht zermatschen). Champignons und Zwiebel klein raspeln. Brokkoli, Champignons, die Zwiebel, Käse und Eier in eine Schüssel geben und vermischen. Flohsamenschalen, Leinsamenmehl, Salz, Pfeffer und Senf dazugeben und verrühren. Aus der Masse Bratlinge formen. Olivenöl in einer Pfanne erhitzen und Bratlinge von beiden Seiten goldbraun anbraten.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '89779823-d00e-4b3f-8ab9-837655d6d3bb',
  'Ensalada de Judías Verdes con Pollo',
  'Grüne Bohnen Hähnchen Salat',
  'lunch',
  355.0,
  30.2,
  19.7,
  9.6,
  '4 PORCIONES',
  '4 PORTIONEN',
  'Lavar las judías y escaldarlas en agua hirviendo con sal durante 4-6 minutos, enfriarlas con agua fría, escurrirlas, cortar los extremos y partir por la mitad. Poner las judías en un bol grande para ensalada. Lavar la pechuga de pollo con agua fría, secar con papel de cocina y cortar en trozos del tamaño de un bocado. Calentar una cucharada de aceite de oliva en la sartén y dorar los trozos de pechuga de pollo, sazonar con sal y pimienta. Sacar la carne de la sartén y reservar, dejar enfriar y añadir a las judías. Partir los tomates por la mitad, cortar la cebolla y los champiñones en trozos pequeños y prensar el ajo. Añadir el aceite restante a la sartén, sofreír brevemente la cebolla y el ajo. Agregar los tomates y los champiñones y rehogar durante 5 minutos, dejar enfriar brevemente y añadir a las judías, mezclar y repartir en cuatro boles individuales. Rociar la ensalada de judías con un poco de zumo de limón y espolvorear por encima una cucharadita de semillas de sésamo. Opcionalmente, también se puede colocar una rodaja de limón en la ensalada.',
  'Bohnen waschen und in kochendem Salzwasser 4-6 Minuten blanchieren, kalt abschrecken, abtropfen lassen, Enden abschneiden und halbieren. Bohnen in eine große Salatschüssel geben. Hähnchenbrust mit kaltem Wasser waschen, trocken tupfen und in mundgerechte Stücke schneiden. Einen Esslöffel Olivenöl in der Pfanne erhitzen und die Hähnchenbruststücke goldig anbraten, mit Salz und Pfeffer würzen. Fleisch aus der Pfanne nehmen und zur Seite stellen, abkühlen lassen und zu den Bohnen geben. Tomaten halbieren, Zwiebel und Champignons klein schneiden und den Knoblauch klein pressen. Das restliche Öl in die Pfanne geben, Zwiebel und Knoblauch kurz andünsten. Tomaten und Champignons dazugeben und 5 Minuten anbraten, kurz abkühlen lassen und zu den Bohnen geben, vermischen und auf vier kleinere Schüsseln verteilen. Bohnen Salat mit etwas Zitronensaft beträufeln und darüber je einen Teelöffel Sesamsamen bestreuen. Optional kann auch eine Zitronenscheibe mit in den Salat gelegt werden.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  'd0c3701f-e3d6-4717-9671-c82e7df02835',
  'Salmón con pimientos',
  'Lachs auf Paprika',
  'lunch',
  356.0,
  40.8,
  13.5,
  14.9,
  '4 PORCIONES',
  '4 PORTIONEN',
  'Precalentar el horno a 200 grados. Lavar los pimientos y cortarlos en trozos pequeños. Pelar la cebolla y el ajo y picarlos finamente. Poner los pimientos, la cebolla y el ajo en una fuente para horno y verter el caldo de verduras. Salpimentar. Colocar los filetes de salmón sobre los pimientos y sazonar con un poco de sal. Cubrir la fuente con papel de aluminio y cocinar durante 30-35 minutos. Repartir los pimientos en cuatro platos. Colocar un trozo en cada plato y rociar con zumo de limón.',
  'Backofen auf 200 Grad vorheizen. Paprika waschen und in kleine Stücke schneiden. Zwiebel und den Knoblauch schälen und klein hacken. Paprika, Zwiebel und Knoblauch in eine Auflaufform geben und die Gemüsebrühe dazu gießen Mit Salz und Pfeffer würzen. Lachsfilets auf die Paprika legen und mit etwas Salz würzen. Auflaufform mit Alufolie bedecken und für 30-35 Minuten garen. Paprika auf vier Tellern verteilen. Auf jeden Teller ein Stück legen und mit Zitronensaft beträufeln.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  'edf09f5d-f2b2-4a8b-b214-074eeafe749f',
  'Low Carb Pincho Moruno',
  'Low Carb Schaschlik',
  'lunch',
  369.0,
  35.9,
  20.1,
  7.8,
  '4 PORCIONES',
  '4 PORTIONEN',
  'Cortar el solomillo de cerdo en dados. Exprimir los limones y mezclar junto con la sal, la pimienta y las semillas de sésamo. Poner los dados de carne en un bol y verter la marinada de limón por encima. Dejar reposar en el refrigerador durante 2 horas. Pelar la cebolla y cortarla en tiras. Ensartar la carne y las tiras de cebolla alternativamente en brochetas y asar a la parrilla o en la sartén por todos los lados.',
  'Schweinefilet in Würfel schneiden. Zitronen auspressen und zusammen mit Salz, Pfeffer und den Sesamsamen vermischen. Fleischwürfel in eine Schüssel geben und mit der Zitronenmarinade übergießen. Für 2 Stunden in den Kühlschrank stellen und ziehen lassen. Zwiebel schälen und in Streifen schneiden. Fleisch und Zwiebelstreifen abwechselnd auf Schaschlik stecken und auf dem Grill oder in der Pfanne von allen Seiten grillen.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '36c8ebfd-4c34-4e41-aa91-58e60f166f92',
  'Pizza Low Carb de Pimiento',
  'Low Carb Pizza Paprika',
  'lunch',
  378.0,
  28.5,
  20.1,
  17.8,
  '2 PIZZAS, 4 PORCIONES',
  '2 PIZZEN, 4 PORTION',
  'Precalentar el horno a 180 grados (calor arriba/abajo). Para la base de pizza, mezclar el queso crema, los huevos y la harina de almendras con una batidora de mano (varillas). Añadir el parmesano y la levadura en polvo y mezclar. Cubrir dos bandejas de horno con papel para hornear. Formar una base de pizza redonda en cada bandeja con la mezcla. Hornear durante aproximadamente 20 minutos. Mientras tanto, se prepara el relleno. Para ello, lavar los pimientos, quitar el tallo y cortar en tiras. Cortar los champiñones y la cebolla en trozos pequeños. Calentar el aceite de oliva en una sartén y sofreír las cebollas. Añadir el concentrado de tomate y los tomates troceados y dejar cocer a fuego lento 2-3 minutos. Sazonar con sal y pimienta. Sacar las bases de pizza del horno y untar con la mezcla de tomate. Distribuir por encima los pimientos, los champiñones y el queso. Hornear durante 10-12 minutos más.',
  'Backofen auf 180 Grad (Ober-/Unterhitze) vorheizen. Für den Pizzaboden Frischkäse, Eier und Mandelmehl mit einem Handrührgerät (Quirlen) verrühren. Parmesan und Backpulver untermischen. Zwei Backbleche mit Backpapier auslegen. Aus der Masse jeweils einen runden Pizzaboden auf je einem Backblech formen. Für circa 20 Minuten backen. In der Zwischenzeit wird der Belag zubereitet. Hierfür die Paprika waschen, Strunk entfernen und in Streifen schneiden. Champignons und Zwiebel klein schneiden. Olivenöl in einer Pfanne erhitzen und Zwiebeln andünsten. Tomatenmark und stückige Tomaten dazugeben und 2-3 Minuten köcheln. Mit Salz und Pfeffer würzen. Die fertigen Pizzaböden aus dem Backofen nehmen und mit der Tomatenmischung bestreichen. Darauf Paprika, Champignons und den Käse verteilen. Für weitere 10-12 Minuten backen.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  'b053565d-a615-4b24-bc00-ce4a210afe03',
  'Berenjena rellena',
  'Gefüllte Aubergine',
  'lunch',
  375.0,
  25.8,
  21.7,
  15.8,
  '4 PORCIONES',
  '4 PORTIONEN',
  'Precalentar el horno a 200 grados (calor arriba/abajo). Lavar las berenjenas, cortar el tallo y partir por la mitad. Extraer la pulpa con una cuchara y cortarla en trozos grandes. Exprimir el limón y rociar las mitades de berenjena con el zumo. Picar finamente la cebolla y el ajo. Añadir aceite de oliva a una sartén y sofreír brevemente la cebolla con el ajo. Agregar la carne picada y dorar. Sazonar con sal, pimienta y pimentón. Añadir la pulpa de la berenjena y sofreír durante 3-5 minutos. Incorporar los tomates troceados y el concentrado de tomate y dejar cocer a fuego lento 2-3 minutos más. Colocar las mitades de berenjena en una fuente para horno y rellenar de manera uniforme con la mezcla de carne picada. Hornear durante 20-25 minutos.',
  'Backofen auf 200 Grad (Ober-/Unterhitze) vorheizen. Auberginen waschen, Strunk abschneiden und halbieren. Das Fruchtfleisch mit einem Löffel auskratzen und in grobe Stücke schneiden. Zitrone auspressen und die Auberginenhälften mit dem Saft beträufeln. Zwiebel und Knoblauch klein hacken. Olivenöl in eine Pfanne geben und Zwiebel mit dem Knoblauch kurz andünsten. Hackfleisch dazugeben und anbraten. Mit Salz, Pfeffer und Paprikapulver würzen. Fruchtfleisch der Aubergine dazugeben und 3-5 Minuten anbraten. Stückige Tomaten und Tomatenmark unterrühren und weitere 2-3 Minuten köcheln. Auberginenhälften in eine Auflaufform legen und mit der Hackfleischmischung gleichmäßig befüllen. Für 20-25 Minuten backen.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '31cadd74-8646-4ed4-a11c-735c0fd1631f',
  'Pechuga de pollo con verduras de coles de Bruselas',
  'Hähnchenbrust mit Rosenkohl-Gemüs',
  'lunch',
  383.0,
  55.3,
  8.9,
  18.0,
  '4 PORCIONES',
  '4 PORTIONEN',
  'Calentar el aceite de oliva en una sartén y dorar la pechuga de pollo por ambos lados. Sazonar con sal y pimienta. Cocer las coles de Bruselas en agua con sal durante 15-20 minutos. Separar el brócoli en ramilletes y pelar las zanahorias. Cortar las zanahorias en rodajas. Retirar el corazón de los pimientos y cortarlos en trozos pequeños. Añadir las coles de Bruselas, el brócoli, las zanahorias baby y los pimientos a la sartén y sofreír aproximadamente 5 minutos. Sazonar con sal y pimienta.',
  'Olivenöl in einer Pfanne erhitzen und die Hähnchenbrust von beiden Seiten goldbraun anbraten. Mit Salz und Pfeffer würzen. Rosenkohl in Salzwasser 15-20 Minuten kochen. Brokkoli in Röschen trennen und Möhren schälen. Möhren in Scheiben schneiden. Das Kerngehäuse der Paprika entfernen und die Paprika klein schneiden. Rosenkohl, Brokkoli, Babykarotten und Paprika in die Pfanne geben und circa 5 Minuten anbraten. Mit Salz und Pfeffer würzen.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '0017cd6c-0e51-4614-9d2c-d089fad2abb2',
  'Pechuga de pavo con verduras',
  'Putenbrust mit Gemüse',
  'lunch',
  388.0,
  59.3,
  7.1,
  19.4,
  '4 PORCIONES',
  '4 PORTIONEN',
  'Calentar el aceite de oliva en una sartén y dorar la pechuga de pavo por ambos lados. Salpimentar. Limpiar el brócoli y las zanahorias. Separar el brócoli en ramilletes y pelar las zanahorias. Cortar las zanahorias en rodajas. Retirar el corazón de los pimientos y cortarlos en trozos pequeños. Cocer el brócoli en agua con sal durante 5 minutos y escurrir a continuación. Añadir las verduras y el maíz a la sartén y sofreír durante aproximadamente 5 minutos. Salpimentar.',
  'Olivenöl in einer Pfanne erhitzen und die Putenbrust von beiden Seiten goldbraun anbraten. Mit Salz und Pfeffer würzen. Brokkoli und Karotten putzen. Brokkoli in Röschen trennen und Karotten schälen. Karotten in Scheiben schneiden. Das Kerngehäuse der Paprika entfernen und die Paprika klein schneiden. Brokkoli in Salzwasser 5 Minuten garen und anschließend abtropfen lassen. Gemüse und Mais in die Pfanne geben und circa 5 Minuten anbraten. Mit Salz und Pfeffer würzen.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  'a45cc207-8083-4996-9ffa-02eb0df629ca',
  'Calabacines rellenos',
  'Gefüllte Zucchini',
  'lunch',
  394.0,
  33.4,
  22.5,
  11.7,
  '4 PORCIONES',
  '4 PORTIONEN',
  'Precalentar el horno a 190 grados. Blanquear los calabacines en agua hirviendo durante 2-3 minutos, enfriar con agua fría y escurrir. Cortar los extremos, partir por la mitad y extraer la pulpa con una cuchara. Cortar la pulpa en trozos pequeños. Picar finamente las cebollas y el ajo. Calentar aceite en una sartén y sofreír las cebollas con el ajo. Añadir la carne picada y sofreír. Salpimentar y añadir el pimentón en polvo. Verter el caldo de verduras. Añadir la pulpa de los calabacines y mezclar. Desmenuzar el queso feta con las manos y añadirlo. Colocar las mitades de calabacín en una fuente para horno una junto a otra y rellenarlas con la mezcla de carne picada. Rociar con un poco de tomate concentrado y hornear durante 30 minutos.',
  'Backofen auf 190 Grad vorheizen. Die Zucchini in kochendem Wasser 2-3 Minuten blanchieren mit kaltem Wasser abschrecken und abtropfen lassen. Enden abschneiden, halbieren und das Fruchtfleisch mit einem Löffel herausholen. Fruchtfleisch klein schneiden. Zwiebeln und Knoblauch klein hacken. Öl in einer Pfanne erhitzen und die Zwiebeln mit dem Knoblauch andünsten. Hackfleisch dazugeben und anbraten. Mit Salz, Pfeffer und Paprikapulver würzen. Mit der Gemüsebrühe ablöschen. Fruchtfleisch der Zucchini dazugeben und verrühren. Schafskäse mit den Händen zerbröckeln und dazugeben. Zucchinihälften in eine Auflaufform nebeneinanderlegen und mit der Hackfleischmischung befüllen. Mit etwas Tomatenmark beträufeln und für 30 Minuten backen.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  'fac72df5-3174-40dd-9e9b-80dedd4dbb40',
  'Gulash de ternera',
  'Rindergulasch',
  'lunch',
  395.0,
  42.0,
  12.5,
  23.9,
  '4 PORCIONES',
  '4 PORTIONEN',
  'Cortar las cebollas en trozos grandes. Prensar los dientes de ajo. Calentar el aceite de oliva en una olla y sofreír las cebollas con el ajo. Añadir la ternera para gulasch y freír hasta que la carne esté completamente cocinada. Agregar el tomate concentrado y el tomate triturado y remover. Sazonar con sal, pimienta y pimentón. Cortar los pimientos en trozos pequeños y añadirlos a la olla. Reducir el fuego y añadir el caldo de verduras. Tapar la olla con una tapa y dejar cocer el gulasch a fuego lento durante 60 minutos.',
  'Zwiebeln in grobe Stücke schneiden. Knoblauchzehen klein pressen. Olivenöl in einem Topf erhitzen und die Zwiebeln mit dem Knoblauch andünsten. Rindergulasch dazugeben und solange braten, bis das Fleisch durch ist. Tomatenmark und passierte Tomaten dazugeben und umrühren. Mit Salz, Pfeffer und Paprikapulver würzen. Paprika klein schneiden und in den Topf geben. Hitze reduzieren und mit der Gemüsebrühe ablöschen. Den Topf mit einem Deckel zudecken und auf kleiner Hitze das Gulasch 60 Minuten köcheln lassen.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '167b9674-841b-4f82-9a56-8915d2c5ad43',
  'Salmón con ensalada de verduras',
  'Lachs mit Gemüsesalat',
  'lunch',
  400.0,
  40.6,
  21.1,
  9.2,
  '4 PORCIONES',
  '4 PORTIONEN',
  'Calentar una cucharada de aceite de oliva en una sartén, añadir el filete de salmón y freír 2-3 minutos por cada lado. Sazonar con sal y pimienta. Apartar el filete de salmón y mantenerlo caliente. Cortar el calabacín en rodajas. Lavar los pimientos y retirar las semillas. Calentar una cucharada de aceite de oliva en una sartén, añadir el calabacín y los pimientos y freír durante aproximadamente 5 minutos. Mezclar las verduras fritas con los tomates y la rúcula y colocar en un plato. Añadir el filete de salmón y rociar con zumo de limón fresco.',
  'Ein Esslöffel Olivenöl in einer Pfanne erhitzen, Lachsfilet hineingeben und von jeder Seite 2-3 Minuten anbraten. Mit Salz und Pfeffer würzen. Lachsfilet zur Seite stellen und warmhalten. Zucchini in Scheiben schneiden. Paprika waschen und das Kerngehäuse entfernen. Ein Esslöffel Olivenöl in einer Pfanne erhitzen, Zucchini und Paprika hineingeben und circa 5 Minuten anbraten. Gebratenes Gemüse mit Tomaten und Rucola vermischen und auf einen Teller legen. Lachsfilet dazugeben und mit frischem Zitronensaft beträufeln.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '0ec0f39a-fd40-4c00-b126-e69871b2ff8e',
  'Salmón con brócoli',
  'Lachs mit Brokkoli',
  'lunch',
  402.0,
  43.8,
  20.5,
  7.7,
  '4 PORCIONES',
  '4 PORTIONEN',
  'Limpiar el brócoli y las zanahorias. Separar el brócoli en ramilletes y pelar las zanahorias. Llevar una olla con agua a ebullición, añadir los ramilletes de brócoli y las zanahorias y cocer durante 6-8 minutos. Calentar aceite de oliva en una sartén y freír el salmón por cada lado durante 2-3 minutos. Sazonar con sal y pimienta. Repartir las verduras en cuatro platos y colocar encima un filete de salmón en cada uno. Servir con romero y rociar el salmón con zumo de limón fresco.',
  'Brokkoli und Möhren putzen. Brokkoli in Röschen trennen und Möhren schälen. Einen Topf mit Wasser zum Kochen bringen, Brokkoliröschen und Möhren hinzugeben und 6-8 Minuten kochen. Olivenöl in einer Pfanne erhitzen und den Lachs von jeder Seite 2-3 Minuten anbraten. Mit Sal und Pfeffer würzen. Gemüse auf vier Teller verteilen und darauf je ein Lachsfilet legen. Mit Rosmarin servieren und den Lachs mit frischem Zitronensaft beträufeln.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  'e0c3521f-349b-4c49-912d-a726e4c0ab2e',
  'Mini Pizza Low Carb',
  'Low Carb Mini Pizza',
  'lunch',
  134.0,
  9.7,
  9.2,
  2.1,
  '12 MINI PIZZAS',
  '12 MINI PIZZEN',
  'Precalentar el horno a 200 grados (calor arriba/abajo). En el primer paso se preparan las bases de pizza. Poner la harina de almendra, la levadura y la sal en un bol y mezclar. Añadir los huevos, el queso crema y el agua y amasar hasta obtener una masa homogénea. Formar 12 pequeñas bases de pizza redondas con la masa. Cubrir una bandeja de horno con papel para hornear y distribuir las bases de pizza una al lado de la otra. Hornear durante aproximadamente 20 minutos. Mientras tanto se prepara el relleno. Para ello, escurrir la mozzarella y cortarla en trozos pequeños. Lavar los pimientos, quitarles las semillas, retirar el tallo y cortar en tiras finas. Partir los champiñones por la mitad y cortarlos en rodajas. Sacar las bases de pizza del horno y cubrirlas con el relleno. Picar finamente el ajo y mezclarlo con el aceite de oliva. Rociar las bases de pizza con la mezcla de aceite y espolvorear con queso. Hornear durante otros 10 minutos (200 grados, calor arriba/abajo).',
  'Backofen auf 200 Grad (Ober-/Unterhitze) vorheizen. Im ersten Schritt werden die Pizzaböden zubereitet. Mandelmehl, Backpulver und Salz in eine Schüssel geben und verrühren. Eier, Frischkäse und Wasser dazugeben und zu einem glatten Teig verkneten. Aus dem Teig 12 runde kleine Pizzaböden formen. Ein Backblech mit Backpapier auslegen und darauf die Pizzaböden nebeneinander verteilen. Für circa 20 Minuten backen. In der Zwischenzeit wird der Belag zubereitet. Hierfür den Mozzarella abtropfen lassen und klein schneiden. Paprika waschen, entkernen, Strunk entfernen und in dünne Streifen schneiden. Champignons halbieren und in Scheiben schneiden. Pizzaböden aus dem Backofen nehmen, mit dem Belag belegen. Knoblauch fein hacken und mit Olivenöl vermischen. Pizzaböden mit der Olivenmischung beträufeln und mit Käse bestreuen. Für weitere 10 Minuten (200 Grad Ober-/Unterhitze) backen.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  'e7157dc1-85af-4080-9ca0-20e38cd26145',
  'Pechuga de pavo con brócoli',
  'Putenbrust mit Brokkoli',
  'lunch',
  406.0,
  54.0,
  13.5,
  11.7,
  '4 PORCIONES',
  '4 PORTIONEN',
  'Lavar la pechuga de pavo y secarla con un papel de cocina. Calentar una cucharada de aceite de oliva en una sartén y dorar la carne por ambos lados. Salpimentar. Limpiar el brócoli y separar los ramilletes del tallo. Cortar las zanahorias en rodajas. Prensar finamente el ajo con un prensador de ajos. Calentar dos cucharadas de aceite de oliva en una sartén, sofreír el ajo y las verduras durante unos 10 minutos a fuego medio. Repartir la carne y las verduras en cuatro platos/boles y rociar con zumo de limón fresco.',
  'Putenbrust waschen und mit einem Küchentuch abtupfen. Ein Esslöffel Olivenöl in einer Pfanne erhitzen und das Fleisch von beiden Seiten goldbraun anbraten. Mit Salz und Pfeffer würzen. Brokkoli putzen und die Röschen vom Stielansatz trennen. Karotten in Scheiben schneiden. Knoblauch mit einer Knoblauchpresse fein pressen. Zwei Esslöffel Olivenöl in einer Pfanne erhitzen, Knoblauch und das Gemüse ca. 10 Minuten auf mittlerer Hitze anbraten. Das Fleisch und Gemüse auf vier Teller/Schüsseln verteilen und mit frischem Zitronensaft beträufeln.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  'a3a68aeb-dd35-4629-a40f-28c2650f82e8',
  'Chili con Carne Especial',
  'Chili con Carne Spezial',
  'lunch',
  411.0,
  31.3,
  21.6,
  19.1,
  '4 PORCIONES',
  '4 PORTIONEN',
  'Picar finamente la cebolla y los dientes de ajo. Calentar el aceite de oliva en la sartén y sofreír la carne picada. Salpimentar y añadir el pimentón. Cortar los tomates y el chile en trozos pequeños. Añadir los tomates, el tomate triturado, el chile, las alubias rojas y el maíz. Verter el caldo de verduras. Mezclar y dejar cocer a fuego lento durante 20 minutos. Servir con perejil fresco picado.',
  'Zwiebel und Knoblauchzehen klein hacken. Olivenöl in der Pfanne erhitzen und das Hackfleisch anbraten. Mit Salz, Pfeffer und Paprikapulver würzen. Tomaten und Chilischote klein schneiden. Tomaten, passierte Tomaten, Chilischote, Kidneybohnen und Mais dazugeben. Mit der Gemüsebrühe ablöschen. Verrühren und auf kleiner Stufe für 20 Minuten köcheln lassen. Mit frisch gehackter Petersilie servieren.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '9ce828e9-daed-4320-be70-d7f25500fcbf',
  'Ensalada mixta con gambas',
  'Gemischter Salat mit Garnelen',
  'lunch',
  437.0,
  34.6,
  28.5,
  7.1,
  '4 PORCIONES',
  '4 PORTIONEN',
  'Descongelar las gambas en un colador, enjuagarlas y escurrirlas bien. Picar los dientes de ajo en trozos pequeños. Calentar el aceite de oliva en una sartén y sofreír brevemente el ajo. Añadir las gambas y freír durante 6-8 minutos. Salpimentar. Cocer los huevos en agua hirviendo durante 8-10 minutos. Trocear la lechuga frisée y los canónigos con las manos y repartirlos en cuatro boles. Cortar los tomates en rodajas y los huevos en cuartos. Repartir los tomates, los huevos y las gambas sobre la ensalada. Para el aliño, exprimir el limón y mezclar el zumo de limón con el aceite de oliva, la sal, la pimienta y el chile en polvo. Rociar el aliño sobre la ensalada y espolvorear con semillas de sésamo.',
  'Garnelen in einem Sieb auftauen lassen, abspülen und gut abtropfen lassen. Knoblauchzehen klein schneiden. Olivenöl in einer Pfanne erhitzen und den Knoblauch kurz andünsten. Garnelen dazugeben und 6-8 Minuten anbraten. Mit Salz und Pfeffer würzen. Eier in kochendem Wasser 8-10 Minuten kochen. Friseesalat und Feldsalat mit den Händen klein zupfen und auf vier Schüsseln verteilen. Tomaten in Scheiben schneiden und Eier vierteln. Tomaten, Eier und Garnelen über den Salat verteilen. Für das Dressing, die Zitrone auspressen und den Zitronensaft mit Olivenöl, Salz, Pfeffer und Chilipulver vermischen. Dressing über den Salat träufeln und mit Sesamsamen bestreuen.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  'c1bc91d3-9d9e-444a-bf07-b6ad5a906d4f',
  'Crema de calabaza',
  'Kürbis Cremesuppe',
  'lunch',
  438.0,
  8.3,
  25.6,
  37.8,
  '4 PORCIONES',
  '4 PORTIONEN',
  'Lavar la calabaza (sin pelar), retirar el tallo y partir por la mitad. Con una cuchara retirar las semillas y cortar la pulpa en trozos pequeños. Pelar la cebolla, el ajo y el jengibre y picarlos finamente. Pelar las zanahorias y cortarlas en trozos pequeños. En una olla grande derretir la mantequilla y sofreír la cebolla, el ajo y el jengibre. Añadir los trozos de calabaza y las zanahorias y verter el caldo de verduras. Sazonar con sal, pimienta y curry en polvo. Dejar cocer a fuego lento durante 15-20 minutos. Triturar la sopa con una batidora de mano, añadir la leche de coco y el zumo de limón y mezclar. Servir la sopa con una cucharadita de crema agria y semillas de calabaza.',
  'Kürbis waschen (nicht schälen), vom Stängel befreien und halbieren. Mit einem Löffel das Kerngehäuse entfernen und das Fruchtfleisch in kleine Stücke schneiden. Zwiebel, Knoblauch und Ingwer schälen und klein schneiden. Möhren schälen und klein schneiden. In einem großen Topf die Butter zum Schmelzen bringen und darin Zwiebel, Knoblauch und Ingwer andünsten. Kürbisstücke und Möhren dazugeben und mit der Gemüsebrühe ablöschen. Mit Salz, Pfeffer und Currypulver würzen. 15-20 Minuten bei niedriger Hitze köcheln lassen. Die Suppe mit einem Pürierstab pürieren, Kokosmilch und Zitronensaft unterrühren. Suppe mit je einem Teelöffel saurer Sahne und Kürbiskernen servieren.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  'ab16650b-7a90-4398-853f-ce8b3ee9285e',
  'Chili Con Carne',
  'Chili Con Carne',
  'lunch',
  440.0,
  30.5,
  25.3,
  18.7,
  '4 PORCIONES',
  '4 PORTIONEN',
  'Picar el ajo finamente. Calentar el aceite de oliva en una olla grande y sofreír el ajo. Añadir la carne picada y freír hasta que la carne esté completamente cocinada. Cortar la zanahoria en rodajas y añadirla junto con el concentrado de tomate. Dejar freír durante 5 minutos. Verter el caldo, añadir el maíz y las alubias rojas y dejar estofar a fuego lento durante 30 minutos. Cortar los pimientos y los tomates en trozos pequeños y añadirlos. Dejar estofar durante 10 minutos más. Por último, añadir la crème fraîche, sazonar con sal y pimienta, remover y servir.',
  'Knoblauch klein schneiden. Olivenöl in einem großen Topf erhitzen und Knoblauch anbraten. Hackfleisch dazugeben und solange anbraten, bis das Fleisch durch ist. Karotte in Scheiben schneiden und zusammen mit Tomatenmark dazugeben. Für 5 Minuten braten lassen. Das Ganze mit der Brühe ablöschen, Mais und Kidneybohnen dazugeben und bei geringer Hitze 30 Minuten schmoren lassen. Die Paprika und die Tomaten klein schneiden und dazugeben. Für weitere 10 Minuten schmoren lassen. Zum Schluss Crème fraîche dazugeben, mit Salz und Pfeffer würzen, umrühren und servieren.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  'bbd41e1f-7bdf-4b9a-9cf1-d26194b6a424',
  'Pimientos rellenos de carne picada y feta',
  'Gefüllte Paprika mit Hack und Feta',
  'lunch',
  442.0,
  30.1,
  30.7,
  7.7,
  '4 PORCIONES',
  '4 PORTIONEN',
  'Precalentar el horno a 200 grados (calor arriba y abajo). Lavar los pimientos y cortar transversalmente el cuarto superior. Retirar las semillas y las membranas blancas interiores. Quitar el tallo y cortar ese trozo de pimiento en trozos pequeños. Pelar la cebolla y los dientes de ajo y picarlos finamente. Calentar el aceite de oliva en la sartén y rehogar la cebolla hasta que esté transparente. Añadir el ajo y la carne picada, sofreír y sazonar con sal, pimienta y pimentón. Añadir el pimiento troceado, verter 150ml de caldo de verduras y dejar cocer a fuego lento 2-3 minutos. Retirar la sartén del fuego, cortar el feta en cubos e incorporar junto con el maíz y el concentrado de tomate a la mezcla de carne picada. Rellenar los pimientos con la mezcla de carne picada y colocarlos en una fuente para horno. Espolvorear con un poco de feta y verter el caldo restante en la fuente. Hornear 25-30 minutos.',
  'Backofen auf 200 Grad (Ober-/Unterhitze) vorheizen. Paprikaschoten waschen, das obere Viertel quer durchschneiden. Die Kerne und weißen Innenhäute entfernen. Stiel entfernen und das Stück Paprika klein schneiden. Zwiebel und Knoblauchzehen schälen und klein hacken. Olivenöl in der Pfanne erhitzen und die Zwiebel glasig andünsten. Knoblauch und Hackfleisch dazugeben, anbraten und mit Salz, Pfeffer und Paprikapulver würzen. Klein geschnittene Paprika dazugeben und mit 150ml Gemüsebrühe ablöschen und 2- 3 Minuten köcheln lassen. Pfanne zur Seite stellen, Feta in Würfel schneiden und zusammen mit dem Mais und Tomatenmark zur Hackfleischmischung unterrühren. Paprikaschoten mit der Hackfleischmischung befüllen und in eine Auflaufform geben. Mit etwas Feta bestreuen und die restliche Brühe in die Auflaufform gießen. 25-30 Minuten backen.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  'd82b57a8-74ab-479e-ad62-04080f037ed7',
  'Ensalada saludable',
  'Gesunder Salat',
  'lunch',
  443.0,
  17.8,
  33.6,
  13.1,
  '4 PORCIONES',
  '4 PORTIONEN',
  'Lavar la escarola y el radicchio y trocearlos en trozos pequeños. Cortar los tomates y los pimientos en trozos pequeños. Cortar la cebolla en aros. Partir el aguacate por la mitad, retirar el hueso y extraer la pulpa con una cuchara. Cortar la pulpa en cubos. Pelar la remolacha y cortarla en cubos de 2 cm. Calentar una cucharada de aceite de oliva en una sartén y sofreír los cubos de remolacha durante 8-12 minutos. Repartir todos los ingredientes en cuatro cuencos y espolvorear con piñones. Desmenuzar el queso de cabra con las manos y repartirlo sobre la ensalada. Para el aliño, mezclar el vinagre con el aceite y sazonar con sal y pimienta. Rociar la ensalada con el aliño.',
  'Friseesalat und Radicchio waschen und klein zupfen. Tomaten und Paprika klein schneiden. Zwiebel in Ringe schneiden. Avocado halbieren, Kern entfernen und das Fruchtfleisch mit einem Löffel herausheben. Fruchtfleisch in Würfel schneiden. Rote Bete schälen und in 2cm große Würfel schneiden. Ein Esslöffel Olivenöl in einer Pfanne erhitzen und darin die Rote Bete Würfel für 8-12 Minuten anbraten. Alle Zutaten auf vier Schüsseln verteilen und mit Pinienkernen bestreuen. Den Ziegenkäse mit den Händen zerbröseln und über den Salat verteilen. Für das Dressing Essig mit Öl vermischen und mit Salz und Pfeffer würzen. Salat mit Dressing beträufeln.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '984d2bfe-0278-4ac2-bfab-751a4fd4de2f',
  'Pimientos rellenos con carne picada',
  'Gefüllte Paprika mit Hackfleisch',
  'lunch',
  448.0,
  29.5,
  27.6,
  16.8,
  '4 PORCIONES',
  '4 PORTIONEN',
  'Precalentar el horno a 200 grados (calor arriba/abajo). Lavar los pimientos, cortar la parte superior y quitar las semillas. Calentar el aceite de oliva en una sartén. Picar finamente la cebolla y el ajo, sofreír brevemente en la sartén y añadir la carne picada. Sazonar con sal, pimienta y pimentón. Cortar los tomates en trozos pequeños y añadirlos a la sartén, sofreír durante 4-5 minutos. Agregar el tomate concentrado y mezclar. Rellenar los pimientos con la mezcla de carne picada, espolvorear con queso y tapar con la tapa del pimiento. Colocar los pimientos uno al lado del otro en una fuente para horno y verter el caldo en la fuente. Hornear durante 15-20 minutos.',
  'Backofen auf 200 Grad (Ober-/Unterhitze) vorheizen. Paprika waschen, den oberen Teil abschneiden und entkernen. Olivenöl in einer Pfanne erhitzen. Zwiebel und Knoblauch klein hacken, in der Pfanne kurz andünsten und das Hackfleisch dazugeben. Mit Salz, Pfeffer und Paprikapulver würzen. Tomaten klein schneiden und mit in die Pfanne geben, 4-5 Minuten anbraten. Tomatenmark dazugeben und verrühren. Hackfleischmischung in die Paprikaschoten füllen, mit Käse bestreuen und mit dem Deckel der Paprika zudecken. Paprikas nebeneinander in eine Auflaufform geben und die Brühe in die Form gießen. Für 15- 20 Minuten backen.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '7d1166f0-0e49-4cf2-bebc-5e2b4735dc9d',
  'Pizza Margarita de harina de almendras',
  'Mandelmehl Pizza Margherita',
  'lunch',
  451.0,
  40.3,
  26.5,
  11.2,
  '2 PIZZAS, 4 PORCIONES',
  '2 PIZZEN, 4 PORTION',
  'Precalentar el horno a 220 grados. Cortar la mozzarella en trozos pequeños y ponerla junto con el quark en un cazo. Derretir a fuego lento. Mezclar la mozzarella derretida, la harina de almendras, los huevos, el agua y la sal en un bol. La masa quedará algo firme, luego amasar con las manos o con un gancho amasador. Si la masa queda demasiado firme, añadir un poco más de agua. Extender la masa formando dos bases redondas de pizza. Cubrir dos bandejas de horno con papel para hornear y colocar una base de pizza en cada bandeja. Pinchar varias veces la base de pizza con un tenedor o un cuchillo afilado. Hornear durante 12-15 minutos. Cubrir las bases de pizza con el tomate triturado y distribuir por encima los tomates troceados. Pelar y picar finamente la cebolla y los dientes de ajo. Cortar los tomates en rodajas. Cubrir las bases de pizza con los ingredientes cortados y espolvorear con queso. Hornear durante otros 12-15 minutos. Espolvorear la pizza con hierbas secas y decorar con hojas de albahaca.',
  'Backofen auf 220 Grad vorheizen. Mozzarella klein schneiden und zusammen mit dem Quark in einen Topf geben. Bei schwacher Hitze zum Schmelzen bringen. Geschmolzenen Mozzarella, Mandelmehl, Eier, Wasser und Salz in einer Schüssel vermischen. Der Teig wird etwas fester, dann mit den Händen oder einem Knethaken verkneten. Wenn der Teig zu fest wird, etwas mehr Wasser dazugeben. Teig zu zwei runden Pizzaböden ausrollen. Zwei Backbleche mit Backpapier auslegen und auf je einem Backblech einen Pizzaboden legen Mit einer Gabel oder einem spitzem Messer mehrere kleine Löcher in den Pizzaboden stechen Für 12-15 Minuten backen. Die Pizzaböden mit den passierten Tomaten bestreichen und die stückigen Tomaten darüber verteilen. Zwiebel und Knoblauchzehen schälen und klein hacken. Tomaten in Ringe schneiden Pizzaböden mit den klein geschnittenen Zutaten belegen und mit Käse bestreuen. Für weitere 12-15 Minuten backen. Pizza mit getrockneten Kräutern bestreuen und mit Basilikumblättern belegen.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '3aad3fd8-adf0-4645-b1f1-e268c1375178',
  'Rollitos de crepes con salmón',
  'Pfannkuchen Lachs Rollen',
  'lunch',
  451.0,
  56.0,
  20.5,
  6.2,
  '4 PORCIONES',
  '4 PORTIONEN',
  'En el primer paso se preparan los crepes. Para ello, mezclar la harina de almendras con la proteína en polvo en un bol. Separar los huevos y añadir las yemas junto con el agua al bol y mezclar con una batidora de mano. Batir las claras a punto de nieve e incorporarlas a la masa. Calentar el aceite en la sartén y hacer los crepes con la masa. A continuación, apartar y dejar enfriar. Colocar un crepe sobre la superficie de trabajo y untarlo con un poco de queso crema y rábano picante. Distribuir encima un poco de rúcula y sobre ella el salmón ahumado. Sazonar con un poco de sal y pimienta. Exprimir el limón y rociar el salmón con un poco de zumo de limón. Enrollar el crepe y cortarlo en trozos más pequeños. Sujetar con un palillo de madera. Repetir los pasos hasta que se hayan usado todos los ingredientes.',
  'Im ersten Schritt werden die Pfannkuchen zubereitet. Hierfür das Mandelmehl mit dem Proteinpulver in einer Schüssel vermischen. Die Eier trennen und das Eigelb mit dem Wasser in die Schüssel geben und mit einem Handrührgerät vermischen. Das Eiklar steif schlagen und unter den Teig heben. Das Öl in der Pfanne erhitzen und aus dem Teig Pfannkuchen backen. Anschließend zur Seite stellen und abkühlen lassen. Einen Pfannkuchen auf die Arbeitsplatte legen und mit etwas Frischkäse und Meerrettich bestreichen. Darauf etwas Rucola verteilen und oben drauf den Räucherlachs. Mit etwas Salz und Pfeffer würzen. Die Zitrone auspressen und den Lachs mit etwas Zitronensaft beträufeln. Den Pfannkuchen zusammenrollen und in kleinere Stücke schneiden. Mit einem Holzspieß befestigen. Schritte solange wiederholen, bis alle Zutaten aufgebraucht sind.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '4ddc37a1-218a-46f2-8fbb-414d628762b3',
  'Zoodles con pollo al sésamo',
  'Zoodles mit Sesam-Hähnchen',
  'lunch',
  452.0,
  31.8,
  29.7,
  10.5,
  '4 PORCIONES',
  '4 PORTIONEN',
  'Lavar los calabacines y las zanahorias, cortar los extremos y cortarlos en largos fideos con un cortador en espiral. Picar el ajo finamente y cortar los champiñones en trozos pequeños. Calentar el aceite de oliva en una sartén y dorar la pechuga de pollo cortada en trozos pequeños, añadir los champiñones y freír 2-3 minutos más. Apartar y mantener caliente. Calentar la mantequilla en una sartén, saltear los fideos de calabacín y zanahoria junto con el ajo durante 2-3 minutos. Sazonar con sal y pimienta. Para el aliño de almendras, poner la mantequilla de almendras, el aceite de sésamo, el zumo de lima y el agua en un recipiente alto y triturar con una batidora de mano durante unos segundos, hasta que los ingredientes se mezclen formando una salsa espesa. Mezclar la pechuga de pollo, los champiñones y las nueces con los fideos y repartir en cuatro platos, rociar con el aliño y espolvorear con semillas de sésamo y semillas de calabaza.',
  'Zucchinis und Möhren waschen, Enden abschneiden und mit einem Spiralschneider in lange Fäden schneiden. Knoblauch klein hacken und die Champignons klein schneiden. Olivenöl in einer Pfanne erhitzen und die klein geschnittene Hähnchenbrust darin goldig anbraten, Champignons dazugeben und weitere 2-3 Minuten braten. Zur Seite stellen und warm halten. Butter in einer Pfanne erhitzen, Zucchini- und Möhrennudeln und den Knoblauch 2-3 Minuten anbraten. Mit Salz und Pfeffer würzen. Für das Mandeldressing, Mandelmus, Sesamöl Limettensaft und das Wasser in ein hohes Gefäß geben und mit einem Pürierstab einige Sekunden pürieren, bis sich die Zutaten dickflüssigen Sauce vermischt haben. Hähnchenrbust, Champignons und die Walnüsse unter die Nudeln mischen und auf vier Teller verteilen, mit Dressing beträufeln, mit Sesamsamen und Kürbiskernen bestreuen.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '61a3f67d-7ecb-4a3c-b1d4-6984a1a189fc',
  'Fideos de calabacín a la boloñesa',
  'Zucchininudeln Bolognese',
  'lunch',
  455.0,
  33.5,
  25.0,
  18.4,
  '4 PORCIONES',
  '4 PORTIONEN',
  'Picar finamente la cebolla y el ajo. Calentar el aceite de oliva en una sartén y sofreír la cebolla con el ajo hasta que estén transparentes. Añadir la carne picada y dorarla. Verter el tomate triturado sobre la carne picada, agregar el concentrado de tomate y sazonar con sal y pimienta. Dejar cocer a fuego lento de 10 a 15 minutos. Lavar los calabacines y cortar los extremos. Con un cortador en espiral, cortar los calabacines en fideos finos. Opcionalmente, los calabacines también se pueden rallar finamente. Cocer los fideos de calabacín en una olla con agua salada hirviendo durante 2-3 minutos. Escurrir y repartir los fideos en cuatro platos. Verter la salsa boloñesa por encima y espolvorear con queso rallado.',
  'Zwiebeln und Knoblauch klein hacken. Olivenöl in einer Pfanne erhitzen und die Zwiebeln mit dem Knoblauch glasig andünsten. Hackfleisch dazugeben und anbraten. Passierte Tomaten über das Hackfleisch gießen, Tomatenmark dazugeben und mit Salz und Pfeffer würzen. Bei niedriger Hitze 10-15 Minuten köcheln. Zucchini waschen und die Enden abschneiden. Mit einem Spiralschneider aus den Zucchini dünne Nudeln schneiden. Optional können die Zucchini auch klein geraspelt werden. Die Zucchininudeln in einem Topf mit kochendem Salzwasser 2-3 Minuten garen. Abgießen und die Nudeln auf vier Teller verteilen. Mit Bolognesesoße übergießen und mit geriebenem Käse bestreuen.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '51faf429-4a47-4c1e-9390-fd5a4c89644e',
  'Calabacines rellenos',
  'Gefüllte Zucchini',
  'lunch',
  458.0,
  36.5,
  27.4,
  11.7,
  '4 PORCIONES',
  '4 PORTIONEN',
  'Partir los calabacines por la mitad a lo largo, cortar los extremos y vaciar la pulpa con una cuchara. (¡No tirar la pulpa!) Calentar el aceite de oliva en una sartén, picar finamente la cebolla y el ajo y rehogarlos en la sartén. Añadir la carne picada y sofreír. Cortar los tomates y los champiñones en trozos pequeños. Añadir a la sartén la pulpa del calabacín, los tomates y los champiñones, verter el caldo de verduras, reducir el fuego y dejar cocer a fuego lento durante 5-10 minutos. Salpimentar al gusto. Precalentar el horno a 180 grados (aire) y cubrir una bandeja de horno con papel de hornear. Colocar las mitades de calabacín una junto a otra sobre la bandeja y rellenarlas con la mezcla de carne picada. Hornear durante 15-20 minutos, luego sacar del horno, espolvorear con el queso y hornear durante 5-10 minutos más. Servir con albahaca fresca picada.',
  'Zucchini längs halbieren, Enden abschneiden und das Fruchtfleisch mit einem Löffel aushöhlen. (Das Fruchtfleisch nicht wegschmeißen!) Olivenöl in einer Pfanne erhitzen, Zwiebel und Knoblauch klein hacken und in der Pfanne andünsten. Hackfleisch dazugeben und anbraten. Tomaten und Champignons klein schneiden. Fruchtfleisch der Zucchini, Tomaten und Champignons in die Pfanne geben, mit Gemüsebrühe ablöschen, Hitze reduzieren und 5-10 Minuten köcheln lassen. Mit Salz und Pfeffer würzen. Backofen auf 180 Grad (Umluft) vorheizen und ein Backblech mit Backpapier auslegen. Die Zucchinihälften nebeneinander auf das Backblech legen und mit der Hackfleischmischung befüllen. Für 15-20 Minuten backen, danach herausnehmen, mit dem Käse bestreuen und für weitere 5 10 Minuten backen. Mit frisch gehacktem Basilikum servieren.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '5a6a2244-9217-435e-be81-b6bf9ae0fc0b',
  'Pechuga de pollo con ensalada',
  'Hähnchenbrust mit Salat',
  'lunch',
  458.0,
  39.3,
  27.0,
  11.0,
  '4 PORCIONES',
  '4 PORTIONEN',
  'Enjuagar la pechuga de pollo con agua fría y secar con papel de cocina. Picar el ajo finamente. Calentar el aceite de oliva en una sartén a fuego medio y sofreír brevemente el ajo. Añadir las pechugas de pollo a la sartén, sazonar por ambos lados con sal, pimienta, pimentón en polvo y chile en polvo y dorar hasta que estén doradas. Limpiar la lechuga, cortarla en trozos pequeños y centrifugarla para secarla, añadir la rúcula. Cortar el pepino en trozos pequeños y partir los tomates por la mitad. Pelar la cebolla y cortarla en aros. Mezclar todos los ingredientes de la ensalada. Para el aliño, mezclar el aceite de oliva, el vinagre de vino blanco, el agua, la sal y la pimienta. Servir la pechuga de pollo con la ensalada, rociar la ensalada con el aliño y decorar con piñones.',
  'Hähnchenbrust kalt abspülen und trocken tupfen. Knoblauch klein hacken. Olivenöl in einer Pfanne bei mittlerer Hitze erhitzen und den Knoblauch kurz andünsten. Hähnchenbrüste in die Pfanne geben, von beiden Seiten mit Salz, Pfeffer, Paprikapulver und Chilipulver würzen und goldbraun anbraten. Kopfsalat putzen, klein schneiden und trockenschleudern, Rucola dazugeben. Salatgurke klein schneiden und Tomaten halbieren. Zwiebel schälen und in Ringe schneiden. Zutaten für den Salat miteinander vermischen. Für das Dressing Olivenöl, Weißweinessig, Wasser, Salz und Pfeffer vermischen. Hähnchenbrust mit Salat servieren, Salat mit dem Dressing beträufeln und mit Pinienkernen garnieren.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  'bc45cf13-fd00-40bb-8962-7b6078dc3d68',
  'Gratinado de calabaza con carne picada',
  'Kürbisauflauf mit Hackfleisch',
  'lunch',
  459.0,
  30.5,
  22.4,
  28.9,
  '4 PORCIONES',
  '4 PORTIONEN',
  'Lavar la calabaza, pelarla, retirar el tallo y partirla por la mitad. Con una cuchara retirar las semillas y cortar la pulpa en trozos pequeños. Cortar la cebolla en trozos pequeños y picar el ajo finamente. Calentar la mantequilla en una sartén y sofreír la cebolla con el ajo hasta que estén transparentes. Añadir la carne picada y dorarla. Incorporar el tomate triturado y el tomate en trozos, sazonar con orégano, pimentón, sal y pimienta y dejar cocer a fuego lento durante 3-5 minutos. Mientras tanto, lavar el pimiento, quitarle las semillas y cortarlo en trozos pequeños. Añadir el pimiento a la sartén y dejar cocer otros 3-5 minutos. Agregar los trozos de calabaza a la sartén, remover y distribuir en una fuente para horno. Hornear en el horno precalentado a 180 grados (calor arriba y abajo) durante 35-40 minutos.',
  'Kürbis waschen, schälen, vom Stängel befreien und halbieren. Mit einem Löffel das Kerngehäuse entfernen und das Fruchtfleisch in kleine Stücke schneiden. Zwiebel klein schneiden und Knoblauch klein hacken. Butter in einer Pfanne erhitzen und die Zwiebel mit dem Knoblauch glasig andünsten. Hackfleisch dazugeben und anbraten. Die passierten und stückigen Tomaten unterrühren, mit Oregano, Paprikapulver, Salz und Pfeffer würzen und 3-5 Minuten köcheln lassen. Währenddessen die Paprika waschen entkernen und klein schneiden. Paprika in die Pfanne geben und weitere 3-5 Minuten köcheln. Kürbisstücke in die Pfanne geben, umrühren und anschließend in eine Auflaufform verteilen. Im vorgeheizten Backofen bei 180 Grad (Ober-/Unterhitze) 35-40 Minuten backen.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '7aa1bc81-1ae9-4f29-bdae-7f27ebc5e0b5',
  'Salmón sobre espinacas con salsa',
  'Lachs auf Spinat mit Dip',
  'lunch',
  463.0,
  29.5,
  34.2,
  5.2,
  '4 PORCIONES',
  '4 PORTIONEN',
  'Enjuagar el salmón y secarlo con papel de cocina. Salpimentar. Calentar dos cucharadas de aceite de oliva en una sartén y freír el salmón durante 6-8 minutos. En una segunda sartén, calentar el resto del aceite de oliva. Prensar finamente el ajo e incorporarlo a la sartén. Añadir las espinacas y rehogarlas. Repartir las espinacas en cuatro platos y colocar un filete de salmón encima de cada uno. Rociar con zumo de limón fresco. Para la salsa, mezclar la crème fraîche con el aceite de oliva y el vinagre. Picar el perejil finamente, exprimir el limón e incorporar todo. Repartir la salsa sobre el salmón y servir.',
  'Lachs abspülen und trocken tupfen. Mit Salz und Pfeffer würzen. Zwei Esslöffel Olivenöl in einer Pfanne erhitzen und den Lachs 6-8 Minuten anbraten. In einer zweiten Pfanne das restliche Olivenöl erhitzen. Knoblauch fein pressen und in die Pfanne geben. Blattspinat in die Pfanne geben und andünsten. Spinat auf vier Teller verteilen und je ein Lachsfilet darüberlegen. Mit frischem Zitronensaft beträufeln. Für den Dip Crème fraîche mit Olivenöl und Essig vermischen. Petersilie klein hacken, Zitrone auspressen und unterrühren. Dip über den Lachs verteilen und servieren.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  'da3bffdb-bc4f-4f17-a3d5-8bf7fea4cf22',
  'Salmón sobre ensalada de rúcula',
  'Lachs auf Rucolasalat',
  'lunch',
  469.0,
  36.8,
  31.0,
  7.7,
  '4 PORCIONES',
  '4 PORTIONEN',
  'Enjuagar el salmón con agua fría y secarlo con papel de cocina. Calentar la mantequilla en una sartén y dorar el salmón por ambos lados durante aproximadamente 3-5 minutos. Salpimentar. Mientras tanto, preparar la ensalada. Lavar la rúcula y la lechuga con agua fría y secarlas. Repartir ambas en cuatro platos. Cortar la cebolla y los tomates en trozos pequeños y distribuirlos sobre la ensalada. Prensar el ajo finamente y mezclarlo con el aceite de oliva. Salpimentar. Verter el aliño sobre la ensalada. Colocar el salmón terminado sobre la ensalada y decorar con rodajas de limón.',
  'Lachs mit kaltem Wasser abspülen und trocken tupfen. Butter in einer Pfanne erhitzen und den Lachs von beiden Seiten etwa 3-5 Minuten goldbraun anbraten. Mit Salz und Pfeffer würzen. In der Zwischenzeit wird der Salat zubereitet. Rucola und Salat mit kaltem Wasser waschen und trocken tupfen. Beides auf vier Tellern verteilen. Zwiebel und Tomaten klein schneiden und über den Salat verteilen. Knoblauch klein pressen und mit Olivenöl vermischen. Mit Salz und Pfeffer würzen. Dressing über den Salat gießen. Den fertigen Lachs über den Salat legen und mit Zitronenscheiben belegen.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  'e3f02c01-a693-4ee7-af43-bea465cf41e8',
  'Gratinado de calabacín y queso',
  'Zucchini Käse Auflauf',
  'lunch',
  469.0,
  35.8,
  29.2,
  10.9,
  '4 PORCIONES',
  '4 PORTIONEN',
  'Precalentar el horno a 200 grados (aire circulante). Pelar las cebollas, cortarlas en trozos pequeños y picar el ajo finamente. Calentar el aceite de oliva en una sartén y sofreír brevemente las cebollas junto con el ajo. Añadir la carne picada, salpimentar y sofreír 1-2 minutos. Agregar los tomates troceados (con el líquido) y dejar cocer a fuego lento durante otros 10-12 minutos. Lavar los calabacines y cortarlos en rodajas. Engrasar una fuente para horno con mantequilla. Distribuir algunas rodajas de calabacín en el fondo de la fuente. Espolvorear un poco de parmesano rallado por encima y verter un poco de la mezcla de carne picada. Luego colocar de nuevo rodajas de calabacín, parmesano y la mezcla de carne picada. Repetir este proceso hasta que se acaben los ingredientes. La capa superior debería terminar con las rodajas de calabacín. Espolvorear el queso rallado por encima y hornear el gratinado durante 20-25 minutos.',
  'Backofen auf 200 Grad (Umluft) vorheizen. Zwiebeln schälen, klein schneiden und Knoblauch feinhacken. Olivenöl in einer Pfanne erhitzen und Zwiebeln zusammen mit dem Knoblauch kurz andünsten Hackfleisch dazugeben, würzen und 1-2 Minuten anbraten. Stückigen Tomaten (mit der Flüssigkeit) dazugeben und für weitere 10-12 Minuten auf kleiner Hitze köcheln lassen. Zucchini waschen und in Scheiben schneiden. Eine Auflaufform mit Butter ausstreichen. Einige Zucchinischeiben auf dem Boden der Auflaufform verteilen. Darüber etwas geriebenen Parmesan streuen und etwas von der Hackfleischmischung darüber gießen. Dann wieder Zucchinischeiben, Parmesan und die Hackfleischmischung darauflegen. Diesen Vorgang so oft wiederholen bis die Zutaten verbraucht sind. Die oberste Schicht sollte mit den Zucchinischeiben enden. Darauf den geriebenen Käse streuen und den Auflauf für 20-25 Minuten backen.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '4b8a5eb8-e181-45e9-b7a2-8704f28f128f',
  'Tortitas de Brócoli y Queso',
  'Brokkoli Käse Puffer',
  'lunch',
  472.0,
  30.8,
  31.1,
  12.5,
  '4 PORCIONES',
  '4 PORTIONEN',
  'Dividir el brócoli en ramilletes y picarlo fino. Mezclar los huevos, el queso rallado, la harina de almendras, el quark y la crema agria en un bol. Cortar la cebolla, el ajo y el cebollino en trozos pequeños y añadirlos. Sazonar con sal y pimienta. Añadir el brócoli, el cebollino y el agua al bol y mezclar. Cubrir el fondo de una sartén con aceite de oliva, calentar a fuego medio y añadir 1-2 cucharadas de masa por tortita en la sartén. Freír por ambos lados hasta que estén crujientes y dorados. Colocar las tortitas sobre papel de cocina y dejar escurrir. Freír las tortitas restantes con el aceite restante.',
  'Brokkoli in Röschen teilen und klein hacken. Eier, Käse (gerieben), Mandelmehl, Quark und Schmand in einer Schüssel vermischen. Zwiebel, Knoblauch und Schnittlauch klein schneiden und dazugeben. Mit Salz und Pfeffer würzen. Brokkoli, Schnittlauch und Wasser in die Schüssel geben und vermischen. Den Boden einer Pfanne mit Olivenöl bedecken, erhitzen (mittlere Hitze) und pro Puffer 1-2 EL Teig in die Pfann geben. Von beiden Seiten kross und goldbraun anbraten. Puffer auf ein Küchenpapier legen und abtropfen lassen. Restliche Puffer mit restlichem Öl braten.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  'a6247d60-aa54-456d-bbed-62019aa8dae7',
  'Nuggets de pollo al horno',
  'Backofen Chicken Nuggets',
  'lunch',
  529.0,
  55.3,
  30.2,
  5.2,
  '4 PORCIONES',
  '4 PORTIONEN',
  'Precalentar el horno a 180 grados (calor arriba y abajo). Enjuagar la pechuga de pollo con agua fría, secar con papel y cortar en trozos gruesos. Sazonar con sal y pimienta. Batir los huevos en un plato hondo con un tenedor. En un plato llano mezclar el parmesano, las almendras molidas y la cúrcuma. Pasar los trozos de carne uno a uno primero por los huevos y luego por la mezcla de almendras, girándolos varias veces para que todos los lados queden completamente cubiertos. Cubrir una bandeja de horno con papel de hornear y distribuir los nuggets uno al lado del otro. Hornear durante 20-25 minutos. Rociar los nuggets con zumo de limón fresco.',
  'Backofen auf 180 Grad (Ober-/Unterhitze) vorheizen. Hähnchenbrust mit kaltem Wasser abspülen, trocken tupfen und in grobe Stücke schneiden. Mit Salz und Pfeffer würzen. Eier in einem tiefen Teller aufschlagen und mit einer Gabel verquirlen. In einem flachen Teller Parmesan, gemahlene Mandeln und Kurkuma vermischen. Fleischstücke einzeln zuerst in den Eiern wälzen und dann in der Mandelmischung mehrmals wenden, sodass alle Seiten vollständig bedeckt sind. Ein Backblech mit Backpapier auslegen und die Nuggets nebeneinander darauf verteilen. Für 20-25 Minuten backen. Nuggets mit frischem Zitronensaft beträufeln.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '810d9e0e-a632-496a-833b-7f388debd8db',
  'Ensalada de pechuga de pollo con aguacate',
  'Hähnchenbrust Avocado Salat',
  'lunch',
  551.0,
  50.2,
  29.7,
  15.8,
  '4 PORCIONES',
  '4 PORTIONEN',
  'Lavar la pechuga de pollo, secarla con papel de cocina y cortarla en 8 trozos grandes. Calentar aceite de oliva en una sartén y dorar las pechugas de pollo por ambos lados. Sazonar con sal y pimienta. Cortar los extremos de las judías y blanquearlas en agua hirviendo durante 5 minutos, luego refrescarlas con agua fría. Lavar las espinacas y la rúcula, centrifugarlas y repartirlas junto con las judías en cuatro boles. Partir el aguacate por la mitad, sacar la pulpa con una cuchara y cortarla en tiras. Cortar los tomates y las cebollas en trozos pequeños y repartirlos junto con las tiras de aguacate sobre la ensalada. Repartir las pechugas de pollo sobre la ensalada. Para el aliño, prensar los dientes de ajo y mezclarlos con el aceite de oliva, el vinagre y el zumo de limón. Sazonar con sal y pimienta. Rociar la ensalada con el aliño.',
  'Hähnchenbrust waschen, trocken tupfen und in 8 große Teilstücke schneiden. Olivenöl in einer Pfanne erhitzen und Hähnchenbrüste von beiden Seiten goldig anbraten. Mit Salz und Pfeffer würzen. Die Enden der Bohnen abschneiden und in kochendem Wasser 5 Minuten blanchieren, anschließend mit kaltem Wasser abschrecken. Spinat und Rucola waschen, trockenschleudern und zusammen mit den Bohnen auf vier Schüsseln verteilen. Avocado halbieren, Fruchtfleisch mit einem Löffel herausnehmen und in Streifen schneiden. Tomaten und Zwiebeln klein schneiden und zusammen mit den Avocadostreifen über dem Salat verteilen. Hähnchenbrüste über den Salat verteilen. Für das Dressing die Knoblauchzehen klein pressen und mit Olivenöl, Essig und Zitronensaft vermischen. Mit Salz und Pfeffer würzen. Salat mit Dressing beträufeln.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '656ce37d-e762-41f9-b715-3463ce166bf2',
  'Wraps de pollo bajos en carbohidratos',
  'Low Carb Chicken Wraps',
  'lunch',
  552.0,
  53.2,
  31.5,
  8.9,
  '4 PORCIONES',
  '4 PORTIONEN',
  'Precalentar el horno a 180 grados (calor arriba y abajo). En el primer paso se prepara la masa del wrap. Para ello, mezclar el requesón, los huevos y el queso en un bol. Distribuir la masa de manera uniforme sobre una bandeja de horno (con papel de hornear) y alisar. Hornear durante 15-20 minutos. Después dejar enfriar la masa del wrap. Para el relleno, cortar la pechuga de pollo en tiras. Calentar el aceite de oliva en una sartén y dorar las tiras de pechuga de pollo. Sazonar con sal y pimienta. Cortar los tomates y la lechuga en trozos pequeños. Exprimir el limón y mezclar el jugo con el queso crema. Untar el wrap con el queso crema, distribuir encima los tomates, la lechuga y la rúcula. Enrollar con cuidado y cortar en cuatro wraps.',
  'Backofen auf 180 Grad (Ober-/Unterhitze) vorheizen. Im ersten Schritt wird der Wrapteig zubereitet. Hierfür Quark, Eier und Käse in einer Schüssel miteinander vermischen. Die Masse auf ein Backblech (mit Backpapier) gleichmäßig verteilen und glattstreichen. 15-20 Minuten backen. Anschießend den Wrapteig auskühlen lassen. Für die Füllung die Hähnchenbrust in Streifen schneiden. Das Olivenöl in einer Pfanne erhitzen und die Hähnchenbruststreifen goldig anbraten. Mit Salz und Pfeffer würzen. Tomaten und Kopfsalat klein schneiden. Zitrone auspressen und den Saft mit Frischkäse vermischen. Den Wrap mit Frischkäse bestreichen, darauf Tomaten, Salat und Rucola verteilen. Vorsichtig zusammenrollen und in vier Wraps schneiden.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '88b7567b-a5d3-4b24-9fc6-483fb08dd09f',
  'Pizza de Coliflor y Rúcula',
  'Blumenkohl Rucola Pizza',
  'lunch',
  594.0,
  56.5,
  30.1,
  19.3,
  '2 PIZZAS, 4 PORCIONES',
  '2 PIZZEN, 4 PORTION',
  'Precalentar el horno a 180 grados (aire caliente). Lavar la coliflor, separar los ramilletes y dejar escurrir. Picar finamente los ramilletes de coliflor o triturarlos en un robot de cocina hasta obtener una consistencia similar a la sémola. Poner la coliflor, el queso, los huevos y la sal en un bol y mezclar. Cubrir dos bandejas de horno con papel para hornear. Formar dos bases de pizza con la masa y distribuirlas en las bandejas. Hornear las bases durante 10 minutos. Lavar la pechuga de pollo, escurrir y cortar en tiras. Picar la cebolla finamente y prensar el ajo. Calentar una cucharadita de aceite de oliva en una sartén, sofreír brevemente la cebolla y el ajo. Incorporar los tomates troceados y el concentrado de tomate. Sazonar con sal y pimienta. En una segunda sartén, calentar el aceite de oliva restante y dorar las tiras de pechuga de pollo. Sacar con cuidado las bandejas del horno y cubrir con la salsa de tomate. Distribuir encima las tiras de pechuga de pollo. Espolvorear el queso rallado por encima, distribuir los tomates y hornear durante 10-15 minutos. Sacar las pizzas del horno y cubrir con rúcula.',
  'Backofen auf 180 Grad (Umluft) vorheizen. Blumenkohl waschen, Röschen abtrennen und abtropfen lassen. Blumenkohlröschen fein hacken oder in einer Küchenmaschine klein häckseln, bis eine grießartige Konsistenz erreicht ist. Blumenkohl, Käse, Eier und Salz in eine Schüssel geben und vermischen. Zwei Backbleche mit Backpapier auslegen. Aus dem Teig zwei Pizzaböden formen und auf den Backblechen verteilen. Pizzaböden für 10 Minuten backen. Hähnchenbrust waschen, abtropfen und in Streifen schneiden. Zwiebel klein schneiden und Knoblauch klein pressen. Einen Teelöffel Olivenöl in einer Pfanne erhitzen, Zwiebeln und Knoblauch kurz andünsten. Stückige Tomaten und Tomatenmark unterrühren. Mit Salz und Pfeffer würzen. In einer zweiten Pfanne das restliche Olivenöl erhitzen und darin die Hähnchenbruststreifen goldbraun anbraten. Backbleche vorsichtig aus dem Backofen nehmen und mit der Tomatensoße bestreichen. Darauf die Hähnchenbruststreifen verteilen. Geriebenen Käse darüber streuen, Tomaten darauf verteilen und für 10-15 Minuten backen. Pizzen aus dem Backofen nehmen und mit Rucola belegen.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '864e4902-9496-4caf-a884-9bb5654cb5e8',
  'Rollitos de Pizza Low Carb',
  'Low Carb Pizzarollen',
  'lunch',
  604.0,
  50.7,
  36.0,
  14.6,
  '4 PORCIONES',
  '4 PORTIONEN',
  'Precalentar el horno a 180 grados (aire circulante). En el primer paso se prepara el rollo de masa. Separar los huevos y batir las claras a punto de nieve. Poner las yemas, el requesón desnatado, la harina de almendras y el queso rallado en un bol y mezclar. Añadir las cáscaras de psyllium, la levadura en polvo y la sal y remover. Incorporar las claras a punto de nieve a la masa. Cubrir una bandeja de horno con papel de hornear y distribuir la masa uniformemente sobre la bandeja. Hornear durante 12-15 minutos. Cortar las cebollas y el ajo en trozos pequeños. Sacar la bandeja del horno. Untar el rollo de masa con los tomates troceados y cubrir con las cebollas, el ajo, las lonchas de queso y el salami. Sazonar con sal y pimienta. Enrollar el rollo de masa y cortarlo en 8-12 piezas. Colocar los trozos de masa uno al lado del otro en una bandeja de horno y espolvorear con queso rallado. Hornear durante otros 10-15 minutos.',
  'Backofen auf 180 Grad (Umluft) vorheizen. Im ersten Schritt wird die Teigrolle zubereitet. Eier trennen und das Eiklar steif schlagen. Eigelbe, Magerquark, Mandelmehl und Käse (gerieben) in eine Schüssel geben und vermischen. Flohsamenschalen, Backpulver und Salz dazugeben und verrühren. Eiklar unter den Teig heben. Ein Backblech mit Backpapier auslegen und den Teig gleichmäßig auf dem Backblech verteilen 12-15 Minuten backen. Zwiebeln und Knoblauch klein schneiden. Das Backblech aus dem Backofen nehmen. Teigrolle mit den stückigen Tomaten bestreichen und mit Zwiebeln, Knoblauch, Käsescheiben und Salami belegen. Mit Salz und Pfeffer würzen. Teigrolle zusammenrollen und in 8-12 Stücke schneiden. Teigstücke nebeneinander auf ein Backblech flach hinlegen und mit geriebenem Käse bestreuen. Für weitere 10-15 Minuten backen.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '111ff8b9-5938-4d3d-b63a-b8c0534f225d',
  'Lasaña Low Carb',
  'Low Carb Lasagne',
  'lunch',
  650.0,
  48.6,
  40.9,
  17.4,
  '4 PORCIONES',
  '4 PORTIONEN',
  'Precalentar el horno a 200 grados (calor arriba y abajo). En el primer paso se preparan las láminas de lasaña. Para ello, mezclar el quark desnatado, el queso rallado y los huevos en un bol. Sazonar con sal. Cubrir una bandeja de horno con papel de hornear y extender la masa uniformemente formando un gran rectángulo. Hornear durante 20 minutos. Mientras tanto, cortar la cebolla en dados. Calentar el aceite de oliva en una sartén y sofreír los dados de cebolla hasta que estén transparentes. Picar el ajo finamente y añadirlo junto con la carne picada. Dorar la carne. Sazonar con sal y pimienta. Añadir el tomate triturado, el tomate en trozos y el concentrado de tomate y mezclar. Despegar con cuidado las láminas de lasaña del papel de hornear y dejar enfriar brevemente. Cortar la masa en tres láminas iguales. Colocar una lámina de lasaña en una fuente para horno, distribuir la mitad de la mezcla de carne picada por encima y verter la mitad de la nata sobre ella. Espolvorear un tercio del queso por encima. Repetir el proceso y espolvorear la lámina superior con el queso restante. Hornear durante otros 15 minutos a 200 grados (calor arriba y abajo). Espolvorear la lasaña con rúcula.',
  'Backofen auf 200 Grad (Ober-/Unterhitze) vorheizen. Im ersten Schritt werden die Lasagneplatten zubereitet. Hierfür Magerquark, geriebenen Käse und Eier in einer Schüssel vermischen. Mit Salz würzen. Ein Backblech mit Backpapier auslegen und den Teig gleichmäßig zu einem großen Rechteck glatt streichen. 20 Minuten backen. In der Zwischenzeit die Zwiebel würfeln. Olivenöl in einer Pfanne erhitzen und Zwiebelwürfel glasig andünsten. Knoblauch fein hacken und mit dem Hackfleisch dazugeben. Fleisch anbraten. Mit Salz und Pfeffer würzen. Passierte Tomaten, stückige Tomaten und Tomatenmar dazugeben und verrühren. Lasagneplatten vorsichtig vom Backpapier lösen und kurz abkühlen lassen. Teig in drei gleichgroße Platten schneiden. Eine Lasagneplatte in eine Auflaufform legen, die Hälfte der Hackfleischmischung darüber verteilen und die Hälfte der Sahne darüber gießen. Ein Drittel vom Käse darüber streuen. Vorgang wiederholen und die obere Platte mit restlichem Käse bestreuen. Für weitere 15 Minuten bei 200 Grad (Ober-/Unterhitze) backen. Lasagne mit Rucola bestreuen.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '413c6d79-6e35-4d9f-8f08-4b3770979e1d',
  'Semillas de chía con frambuesas',
  'Chia Samen mit Himbeeren',
  'snack',
  112.0,
  6.5,
  4.9,
  9.7,
  '1 PORCIÓN',
  '1 PORTION',
  'Verter la leche en un bol y mezclar las semillas de chía. Dejar en el frigorífico durante 60 minutos. Durante este tiempo las semillas de chía se hincharán. Triturar 40g de frambuesas, mezclar con el zumo de limón y el edulcorante. Reservar el resto de las frambuesas para el topping. Sacar las semillas de chía del frigorífico. Poner las frambuesas trituradas en una copa de postre, añadir encima las semillas de chía y distribuir el resto de las frambuesas por encima.',
  'Milch in eine Schüssel geben und die Chia Samen einrühren. Für 60 Minuten in den Kühlschrank stellen. In dieser Zeit quellen die Chia Samen auf. 40g Himbeeren pürieren, mit Zitronensaft und Süßstoff vermischen. Die restlichen Himbeeren für das Topping aufbewahren. Chia Samen aus dem Kühlschrank nehmen. Pürierte Himbeeren in ein Dessertglas geben, darüber die Chia Samen geben und darauf die restlichen Himbeeren verteilen.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '35fab555-8e41-4615-95fd-0a5c7a139aa0',
  'Chips de Calabacín',
  'Zucchini Chips',
  'snack',
  119.0,
  5.1,
  8.6,
  4.3,
  '1 PORCIÓN',
  '1 PORTION',
  'Precalentar el horno a 120 grados (calor arriba y abajo). Lavar el calabacín y cortar los extremos. Cortar el calabacín en rodajas finas. Poner el vinagre de manzana, el aceite de oliva, el parmesano y la sal en un bol y mezclar. Añadir las rodajas de calabacín al bol y remover con cuidado para que todas las rodajas queden marinadas. Cubrir dos bandejas de horno con papel para hornear y distribuir las rodajas una al lado de la otra. Hornear durante 50-60 minutos. Despegar los chips de calabacín del papel para hornear mientras aún estén calientes, ya que al enfriarse se pegarán al papel.',
  'Backofen auf 120 Grad (Ober-/Unterhitze) vorheizen. Zucchini waschen und die Enden abschneiden. Die Zucchini in dünne Scheiben schneiden. Apfelessig, Olivenöl, Parmesan und Salz in eine Schüssel geben und verrühren. Zucchinischeiben in die Schüssel geben und vorsichtig umrühren, sodass alle Zucchinischeiben mariniert sind. Zwei Backbleche mit Backpapier auslegen und darauf die Scheiben nebeneinander verteilen. Für 50-60 Minuten backen. Zucchinichips noch im warmen Zustand vom Backpapier lösen, wenn sie abkühlen verkleben sie mit dem Backpapier.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '93b37906-18d8-43a3-af2e-ced170496cd4',
  'Hamburguesa de Manzana y Mantequilla de Cacahuete',
  'Apfel Erdnussbutter Burger',
  'snack',
  141.0,
  3.0,
  6.1,
  0,
  '1 PORCIÓN',
  '1 PORTION',
  'Lavar la manzana, secarla con papel y cortarla en rodajas. Asegurarse de que las rodajas de manzana no queden demasiado finas. Recortar el corazón con un cuchillo, de modo que quede un círculo vacío en el centro. Untar las rodajas de manzana con mantequilla de maní. Cubrir la mitad de las rodajas de manzana con arándanos y tapar con la otra mitad de las rodajas de manzana.',
  'Apfel waschen, trocken tupfen und in Scheiben schneiden. Darauf achten, dass die Apfelscheiben nicht zu dünn werden. Das Kerngehäuse mit einem Messer ausschneiden, sodass ein leerer Kreis in der Mitte ist. Apfelscheiben mit Erdnussbutter bestreichen. Die Hälfte der Apfelscheiben mit Blaubeeren belegen und mit der anderen Hälfte an Apfelscheiben zudecken.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  'edb3c1a4-1c87-4da5-b43d-9a129ee26d68',
  'Pudín de arándanos y chía',
  'Blaubeeren Chia Pudding',
  'snack',
  159.0,
  5.4,
  9.7,
  11.1,
  '1 PORCIÓN',
  '1 PORTION',
  'Poner la leche y las semillas de chía en un bol y mezclar. Dejar en el refrigerador durante 2-3 horas. Poner los arándanos en un recipiente alto, añadir el zumo de limón y triturar con una batidora de mano. Reservar unos 30g de arándanos para el topping. Distribuir la mezcla de arándanos y las semillas de chía alternativamente en una copa de postre. Esparcir el coco rallado por encima y distribuir los arándanos restantes sobre el pudín.',
  'Milch und Chia Samen in eine Schüssel geben und verrühren. Für 2-3 Stunden in den Kühlschrank stellen. Blaubeeren in ein hohes Gefäß geben, Zitronensaft dazugeben und mit einem Stabmixer pürieren. Etwa 30g der Blaubeeren für das Topping übrig lassen. Die Blaubeermasse und die Chia Samen abwechselnd in ein Dessertglas verteilen. Kokosraspeln darüber streuen und die restlichen Blaubeeren über den Pudding verteilen.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '04eb3c6d-52a6-4000-98dd-5ed70307ef88',
  'Pudín de chocolate y chía',
  'Schoko-Chia Pudding',
  'snack',
  149.0,
  8.0,
  10.0,
  5.7,
  '1 PORCIÓN',
  '1 PORTION',
  'Poner la leche, las semillas de chía, el cacao en polvo, el edulcorante y la sal en un bol y mezclar. Tapar y dejar en el refrigerador durante 6-8 horas. Remover con un tenedor después de una hora. (Mejor preparar la noche anterior) Esparcir las almendras laminadas por encima y opcionalmente colocar una fresa como decoración sobre el pudín.',
  'Milch, Chia Samen, Backkakao, Süßstoff und Salz in eine Schüssel geben und vermischen. Zugedeckt für 6-8 Stunden in den Kühlschrank stellen. Nach einer Stunde mit einer Gabel verrühren. (Am besten am Vorabend zubereiten) Mit Mandelblättchen bestreuen und optional eine Erdbeere als Garnitur auf den Pudding legen.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '485c5a04-5a4d-4047-b947-7b077c24c84a',
  'Rollitos de pepino rellenos',
  'Gefüllte Gurken Röllchen',
  'snack',
  212.0,
  21.3,
  8.7,
  10.6,
  '1 PORCIÓN',
  '1 PORTION',
  'Lavar el pepino, secarlo y cortar los extremos. Cortar tiras largas con un pelador de verduras o un cortador de queso. Mezclar el queso crema, el jugo de limón, el eneldo, la sal y la pimienta. Cortar el jamón cocido y el queso en tiras largas y anchas. Colocar las tiras de pepino una al lado de la otra y cubrir con queso. Untar con queso crema y distribuir el jamón cocido encima. Enrollar (con algo de presión) y fijar los rollos con palillos o mondadientes para que el rollo no se abra.',
  'Gurke waschen, abtrocknen und die Enden abschneiden. Mit einem Gemüseschäler oder Käsehobel lange Streifen schneiden. Frischkäse, Zitronensaft, Dill, Salz und Pfeffer miteinander vermischen. Kochschinken und Käse in lange breite Streifen schneiden. Gurkenstreifen nebeneinanderlegen und mit Käse belegen. Mit Frischkäse bestreichen und darauf den Kochschinken verteilen. Zusammenrollen (ruhig mit etwas Druck) und die Rollen mit Stäbchen bzw. Zahnstochern befestigen, damit die Rolle sich nicht öffnet.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  'e5d144d7-cad0-4ad1-8fc2-2c4f632ec08c',
  'Yogur con frutos rojos',
  'Joghurt mit Beeren',
  'snack',
  178.0,
  12.1,
  3.7,
  22.5,
  '1 PORCIÓN',
  '1 PORTION',
  'Poner el yogur y el edulcorante en un tazón y mezclar. Exprimir el limón, agregar el jugo y revolver. Distribuir los frutos rojos sobre el yogur. También se pueden elegir otras frutas del bosque.',
  'Joghurt und Süßstoff in eine Schüssel geben und vermischen. Zitrone auspressen, Saft dazugeben und verrühren. Beeren über den Joghurt verteilen. Es können auch andere Beeren gewählt werden.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '3faf90dc-5b23-443d-83cb-0fcbcb459e31',
  'Pudín de chía con arándanos',
  'Chia Pudding mit Blaubeeren',
  'snack',
  179.0,
  5.4,
  12.0,
  11.1,
  '1 PORCIÓN',
  '1 PORTION',
  'Mezclar la leche con las semillas de chía, el edulcorante y el aroma de vainilla. Refrigerar durante 2-3 horas. Durante ese tiempo, las semillas de chía se hincharán. Servir con almendras laminadas y arándanos.',
  'Milch mit Chia Samen, Süßstoff und Vanillearoma vermischen. Für 2-3 Stunden kalt stellen. In der Zeit quellen die Chia Samen auf. Mit Mandelblättchen und Blaubeeren servieren.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '7c13b499-591e-4708-a493-dbcb843bde8c',
  'Pudín de mango y yogur',
  'Mango-Joghurt Pudding',
  'snack',
  190.0,
  4.9,
  10.3,
  18.2,
  '1 PORCIÓN',
  '1 PORTION',
  'Pelar y deshuesar el mango. Exprimir el zumo de lima y junto con el mango (reservar algunos trozos de mango para el topping) triturar con una batidora de mano hasta obtener una masa espesa. Mezclar la leche con el yogur griego. Añadir el edulcorante y remover. Poner la mitad de la crema de mango en un vaso, distribuir una capa de yogur encima. Añadir el resto de la crema de mango y distribuir el yogur restante encima. Utilizar los trozos de mango reservados como topping.',
  'Mango schälen und entkernen. Limettensaft auspressen und zusammen mit der Mango (einige Mangostücke für das Topping zur Seite stellen) mit einem Stabmixer pürieren, bis eine dickflüssige Masse entsteht. Milch mit dem griechischen Joghurt vermischen. Süßstoff dazugeben und verrühren. Die Hälfte der Mangocreme in ein Glas geben, darüber eine Schicht Joghurt verteilen. Darauf die restliche Mangocreme geben und darauf den restlichen Joghurt verteilen. Die zur Seite gestellten Mangostücke als Topping benutzen.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '2318330a-3a8f-43a6-bd5b-cf28545c42ad',
  'Crema de Arándanos',
  'Heidelbeeren Creme',
  'snack',
  210.0,
  15.1,
  8.3,
  16.5,
  '1 PORCIÓN',
  '1 PORTION',
  'Poner el huevo y la leche (50ml) en un bol y batir con un batidor de varillas. Poner el resto de la leche con la harina de algarroba y el edulcorante en un cazo y llevar brevemente a ebullición. Cuando la leche hierva, retirar del fuego, incorporar la mezcla de huevo y volver a llevar brevemente a ebullición. Triturar 40g de arándanos y pasarlos por un colador para que no queden trozos de piel. Mezclar el zumo de limón con los arándanos. Añadir los arándanos, el yogur y la sal a la crema y mezclar. Dejar en el frigorífico durante 2-3 horas. Decorar con los arándanos restantes y menta fresca.',
  'Ei und Milch (50ml) in eine Schüssel geben und mit einem Schneebesen verschlagen. Die restliche Milch mit Johannisbrotkernmehl und Süßstoff in einen Topf geben und kurz aufkochen. Wenn die Milch aufkocht, vom Herd nehmen und die Eiermischung unterrühren und nochmals kurz aufkochen. 40g Heidelbeeren pürieren und durch ein Sieb pressen, sodass keine Hautstücke mehr vorhanden sind. Zitronensaft unter die Heidelbeeren rühren. Heidelbeeren, Joghurt und Salz zur Creme geben und vermischen. Für 2-3 Stunden in den Kühlschrank stellen. Mit den restlichen Heidelbeeren und frischer Minze dekorieren.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '398b8848-7d84-4d35-bccc-61a800464b4b',
  'Queso fresco desnatado con frambuesas',
  'Magerquark mit Himbeeren',
  'snack',
  210.0,
  35.0,
  1.0,
  14.7,
  '1 PORCIÓN',
  '1 PORTION',
  'Poner el quark desnatado, el edulcorante y el agua en un bol y mezclar. Añadir las frambuesas (descongeladas) y remover. También se pueden usar frambuesas frescas.',
  'Magerquark, Süßstoff und Wasser in eine Schüssel geben und vermischen. Himbeeren (aufgetaut) unterrühren. Es können auch frische Himbeeren verwendet werden.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  'bc38f094-b7d9-4e31-9ad6-158ffa9d9a29',
  'Brownie de microondas',
  'Mikrowellen Brownie',
  'snack',
  212.0,
  31.4,
  7.3,
  4.0,
  '1 BROWNIE',
  '1 BROWNIE',
  'Poner la proteína en polvo, el cacao, el xilitol y la levadura en una taza apta para microondas y mezclar. Añadir el huevo y la leche y remover hasta obtener una masa homogénea. Hornear en el microondas durante 2-3 minutos a 700 vatios.',
  'Proteinpulver, Backkakao, Xylit und Backpulver in eine mikrowellenfeste Tasse geben und vermischen. Ei und Milch dazugeben und zu einer glatten Masse verrühren. Für 2-3 Minuten bei 700 Watt in der Mikrowelle backen.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '2e11b80d-e814-4032-981b-cbe49aaeaecf',
  'Pastel en taza',
  'Tassenkuchen',
  'snack',
  213.0,
  26.0,
  10.3,
  2.8,
  '1 PASTEL EN TAZA',
  '1 TASSENKUCHEN',
  'Poner la harina de almendras, el cacao, la proteína en polvo, la levadura y la sal en una taza apta para microondas y mezclar. Añadir la leche, el huevo, el aceite de coco y el edulcorante y mezclar hasta obtener una masa homogénea. Hornear en el microondas durante 2-3 minutos a 700 vatios. Opcionalmente, espolvorear con xilitol en polvo.',
  'Mandelmehl, Backkakao, Proteinpulver, Backpulver und Salz in eine mikrowellenfeste Tasse geben und verrühren. Milch, Ei, Kokosöl und Süßstoff dazugeben und zu einer glatten Masse vermischen. Für 2-3 Minuten bei 700 Watt in der Mikrowelle backen. Optional mit Puder-Xylit bestreuen.'
);
INSERT INTO recipes (id, name_es, name_de, category, calories_per_serving, protein, fat, carbs, servings_note_es, servings_note_de, instructions_es, instructions_de) VALUES (
  '06c0f13a-1d2e-4fee-84d3-4aec214aa10f',
  'Quark desnatado con bayas',
  'Magerquark mit Beeren',
  'snack',
  215.0,
  35.0,
  1.3,
  16.0,
  '1 PORCIÓN',
  '1 PORTION',
  'Poner el quark desnatado, el edulcorante y el agua en un bol y mezclar. Añadir las frambuesas (descongeladas) y los arándanos (descongelados) y remover. También se pueden usar bayas frescas.',
  'Magerquark, Süßstoff und Wasser in eine Schüssel geben und vermischen. Himbeeren (aufgetaut) und Heidelbeeren (aufgetaut) unterrühren. Es können auch frische Beeren verwendet werden.'
);

-- ================================================
-- INSERT INGREDIENTS
-- ================================================

INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('e76117b0-34ac-408f-b9e8-fabf1784513d', '8d9c67d7-939b-4ac4-9c16-df25edcca168', 'harina de almendra', 'Mandelmehl', 160.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('7fbb88f8-2d83-4de3-ac40-4976f76b0b6e', '8d9c67d7-939b-4ac4-9c16-df25edcca168', 'huevos', 'Eier', 3.0, '', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('038daa1b-15ec-41ba-af94-fe7fc55410b6', '8d9c67d7-939b-4ac4-9c16-df25edcca168', 'calabacín', 'Zucchini', 1.0, '', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('103dfd82-dafb-4888-85f8-79959fe9400a', '8d9c67d7-939b-4ac4-9c16-df25edcca168', 'levadura en polvo', 'Backpulver', 2.0, 'cucharaditas', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('db248bdb-2b03-4014-b076-55e3db115242', '8d9c67d7-939b-4ac4-9c16-df25edcca168', 'aceite de coco', 'Kokosöl', 2.0, 'cucharaditas', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('7e4f4834-ca5e-4b79-a820-3337442afffa', '8d9c67d7-939b-4ac4-9c16-df25edcca168', 'xilitol (Xucker)', 'Xylit (Xucker)', 20.0, 'g', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('c97b6046-28e5-4a6f-a608-3d8593802621', '8d9c67d7-939b-4ac4-9c16-df25edcca168', 'nueces', 'Walnüsse', 40.0, 'g', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('585b057d-9544-45ec-9691-d437b2a99c7d', '8d9c67d7-939b-4ac4-9c16-df25edcca168', 'canela', 'Zimt', 1.0, 'cucharadita', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('ecca9c10-a275-4727-afc6-b57b5aa67341', '8d9c67d7-939b-4ac4-9c16-df25edcca168', 'sal', 'Salz', 1.0, 'pizca', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('aa39deb8-0616-44b8-987e-73362e1a96ac', '7ea965c6-017d-466f-8035-ee71ee778ff9', 'huevos', 'Eier', 5.0, '', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('717815d5-e99b-47a1-b44f-df42cabfc95e', '7ea965c6-017d-466f-8035-ee71ee778ff9', 'quark (40% de grasa)', 'Quark (40% Fett)', 250.0, 'g', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('ba5daa75-b622-4ed7-842f-9fda11518e71', '7ea965c6-017d-466f-8035-ee71ee778ff9', 'sal', 'Salz', 0.5, 'cucharadita', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('d8dc9f95-e130-4eb6-8663-f588ca71d0c1', '7ea965c6-017d-466f-8035-ee71ee778ff9', 'levadura en polvo', 'Backpulver', 0.5, 'cucharadita', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('4e228089-7c32-4743-bd62-3492fe06e19c', 'f3d9cfb3-0d4a-4e10-a9d1-0561a2dad1ea', 'harina de almendra', 'Mandelmehl', 200.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('347af471-00c9-4f4a-b36e-e47351d6beaa', 'f3d9cfb3-0d4a-4e10-a9d1-0561a2dad1ea', 'cáscaras de psyllium', 'Flohsamenschalen', 30.0, 'g', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('6a822fc8-35b2-4fc1-b544-d432658b86f5', 'f3d9cfb3-0d4a-4e10-a9d1-0561a2dad1ea', 'huevos', 'Eier', 4.0, '', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('2ce5122c-4841-4d4c-b4ee-59a6a6d18b97', 'f3d9cfb3-0d4a-4e10-a9d1-0561a2dad1ea', 'sal', 'Salz', 0.5, 'cdta', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('b5302852-b3ad-4d5b-9f99-b81fa6f86142', 'f3d9cfb3-0d4a-4e10-a9d1-0561a2dad1ea', 'avellanas', 'Haselnüsse', 40.0, 'g', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('3e504045-e77b-4abc-b7c2-022d2216e558', 'f3d9cfb3-0d4a-4e10-a9d1-0561a2dad1ea', 'sobre de levadura en polvo', 'Backpulver', 0.5, 'Packung', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('e49a974a-0965-4822-a5ef-ee6cf43d0eee', 'f3d9cfb3-0d4a-4e10-a9d1-0561a2dad1ea', 'agua (tibia)', 'Wasser (warm)', 180.0, 'ml', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('f297f9cc-c1e9-4e03-b118-f3c8f8d18d37', '018f66b7-0147-4bdf-9fc4-456dd7b9c223', 'harina de almendra', 'Mandelmehl', 40.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('81b5fe3d-9769-45e6-b4f4-a98b25a83d1f', '018f66b7-0147-4bdf-9fc4-456dd7b9c223', 'mozzarella (baja en grasa)', 'Mozzarella (fettarm)', 40.0, 'g', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('e3534f2d-d0dc-4bda-b518-66d34aaa663d', '018f66b7-0147-4bdf-9fc4-456dd7b9c223', 'queso crema (bajo en grasa)', 'Frischkäse (fettarm)', 2.0, 'cdas', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('5524fa54-40f4-4c37-ae2a-c8d192347ed8', '018f66b7-0147-4bdf-9fc4-456dd7b9c223', 'huevo', 'Ei', 1.0, '', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('1fe19b2b-9417-4245-b6cd-01df4079907f', '018f66b7-0147-4bdf-9fc4-456dd7b9c223', 'levadura en polvo', 'Backpulver', 0.5, 'cdta', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('0133eb7a-f2f1-4078-9042-8744e6ac7040', '018f66b7-0147-4bdf-9fc4-456dd7b9c223', 'semillas de sésamo', 'Sesamsamen', 1.0, 'cda', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('3a909325-8532-4b1e-ba49-b4f589826e91', '018f66b7-0147-4bdf-9fc4-456dd7b9c223', 'sal', 'Salz', 1.0, 'pizca', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('f739f4be-fb3b-4984-88b4-ce688f3716e0', '017a31e9-8eb3-44fb-bdc0-d1bb2ab15aec', 'requesón (40% de grasa)', 'Quark (40% Fett)', 500.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('baa4c9f5-1b3a-471e-bdd4-c82b1cfa5792', '017a31e9-8eb3-44fb-bdc0-d1bb2ab15aec', 'huevos', 'Eier', 5.0, '', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('88fb66d4-cd41-4009-9ce6-7e14304702f8', '017a31e9-8eb3-44fb-bdc0-d1bb2ab15aec', 'harina de almendras', 'Mandelmehl', 220.0, 'g', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('a2430c3d-7dfc-437d-aa53-2a58a54a8b47', '017a31e9-8eb3-44fb-bdc0-d1bb2ab15aec', 'semillas de lino (molidas)', 'Leinsamen (geschrotet)', 120.0, 'g', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('7790ae30-b680-429d-939b-e0f8f0d01244', '017a31e9-8eb3-44fb-bdc0-d1bb2ab15aec', 'semillas de lino', 'Leinsamen', 50.0, 'g', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('0f9d4ece-649c-4413-9378-8c40ee23f112', '017a31e9-8eb3-44fb-bdc0-d1bb2ab15aec', 'pipas de girasol', 'Sonnenblumenkerne', 30.0, 'g', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('6b09c9af-23ef-4c94-a1c0-b89942afa74c', '017a31e9-8eb3-44fb-bdc0-d1bb2ab15aec', 'salvado de avena', 'Haferkleie', 50.0, 'g', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('4609b289-ab22-496d-b89d-f90d08940458', '017a31e9-8eb3-44fb-bdc0-d1bb2ab15aec', 'harina de algarroba', 'Johannisbrotkernmehl', 2.0, 'cucharadas', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('5e331f63-36ac-42cd-91c3-d1ceb43d27e4', '017a31e9-8eb3-44fb-bdc0-d1bb2ab15aec', 'bicarbonato de sodio', 'Natron', 1.0, 'cucharadita', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('eda336bc-9d9b-43b7-8938-6b21e3610ea7', '017a31e9-8eb3-44fb-bdc0-d1bb2ab15aec', 'sal', 'Salz', 1.0, 'cucharadita', 10);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('616251f6-a05e-476e-b7b6-db712d5bc2ae', 'fe99ad2f-7cee-4f15-b077-346e869edaed', 'requesón desnatado', 'Magerquark', 30.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('ffd26bcb-696b-42e0-8a14-a533fc323b27', 'fe99ad2f-7cee-4f15-b077-346e869edaed', 'harina de almendras', 'Mandelmehl', 40.0, 'g', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('84403a21-51ee-407f-b2b2-a86cc136c9ee', 'fe99ad2f-7cee-4f15-b077-346e869edaed', 'mantequilla', 'Butter', 20.0, 'g', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('37b597d9-4e75-4a85-b11b-f81894df4739', 'fe99ad2f-7cee-4f15-b077-346e869edaed', 'huevo', 'Ei', 1.0, '', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('dc20adc4-9551-435a-b11f-9bb1dd8dd56b', 'fe99ad2f-7cee-4f15-b077-346e869edaed', 'levadura en polvo', 'Backpulver', 0.5, 'cucharadita', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('57f58fec-21c7-48e8-a4b1-4d138c1d1599', 'fe99ad2f-7cee-4f15-b077-346e869edaed', 'cáscaras de psyllium', 'Flohsamenschalen', 0.5, 'cucharadita', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('21f4c837-191f-412f-a2c6-2f2b6ec5a99e', 'fe99ad2f-7cee-4f15-b077-346e869edaed', 'sal', 'Salz', 1.0, 'pizca', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('ea2fbf10-b856-488c-8ac4-88825000bbbf', '61733671-159e-433f-8ba7-7300d357168e', 'almendras (molidas)', 'Mandeln (gemahlen)', 100.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('61759dcc-7feb-47ad-87a3-2d420cba7a01', '61733671-159e-433f-8ba7-7300d357168e', 'harina de coco', 'Kokosmehl', 1.0, 'cda', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('db68643e-129c-4fda-b036-9017b597bffc', '61733671-159e-433f-8ba7-7300d357168e', 'huevos', 'Eier', 3.0, '', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('4aa71349-2dc3-49c0-877f-677123ef3dec', '61733671-159e-433f-8ba7-7300d357168e', 'quark (40% grasa)', 'Quatk (40% Fett)', 250.0, 'g', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('5b5d4e3f-0345-453b-bf82-6f2f9307e86a', '61733671-159e-433f-8ba7-7300d357168e', 'psyllium en polvo', 'Flohsamenschalenpulver', 4.0, 'cdas', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('b1046adb-15bb-44e9-ab3a-f0ff09d882f4', '61733671-159e-433f-8ba7-7300d357168e', 'sal', 'Salz', 0.5, 'cdta', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('f5e8df87-6a24-4dc0-af4d-4c6e4aad6bd9', '61733671-159e-433f-8ba7-7300d357168e', 'levadura en polvo', 'Backpulver', 2.0, 'cdtas', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('c43cf524-ba69-44af-82b1-6155b449c7d8', '61733671-159e-433f-8ba7-7300d357168e', 'queso (rallado)', 'Käse (gerieben)', 60.0, 'g', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('63915f6d-a38b-4e5f-8f41-11f6d3addb9c', 'df37368c-dd71-4e2d-9e54-465ef0e96c7d', 'semillas de lino dorado (molidas)', 'Goldleinsamen (gemahlen)', 100.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('62ecf330-67f3-4b46-a515-ce9983e58377', 'df37368c-dd71-4e2d-9e54-465ef0e96c7d', 'harina de coco', 'Kokosmehl', 50.0, 'g', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('2ee547c3-37be-469b-8855-2da4edeae632', 'df37368c-dd71-4e2d-9e54-465ef0e96c7d', 'mozzarella', 'Mozzarella', 200.0, 'g', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('0713af31-9c6c-4f0b-b80f-1d1306433324', 'df37368c-dd71-4e2d-9e54-465ef0e96c7d', 'quark (40% grasa)', 'Quark (40% Fett)', 60.0, 'g', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('220f5748-67a0-4ed6-b3d5-6f1f56a985f3', 'df37368c-dd71-4e2d-9e54-465ef0e96c7d', 'sal', 'Salz', 1.0, 'pizca', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('45a60b1d-9efd-45ec-8f7a-70d87f2854f7', 'df37368c-dd71-4e2d-9e54-465ef0e96c7d', 'huevos', 'Eier', 2.0, '', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('07adad23-9524-43fb-8a5a-bd40ee2f75aa', 'df37368c-dd71-4e2d-9e54-465ef0e96c7d', 'yema de huevo', 'Eigelb', 1.0, '', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('cef9aefd-b379-42fb-8785-d7806cea4484', 'df37368c-dd71-4e2d-9e54-465ef0e96c7d', 'levadura en polvo', 'Backpulver', 2.0, 'cdtas', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('e409e210-4ce9-4261-b2d4-992559e03039', 'df37368c-dd71-4e2d-9e54-465ef0e96c7d', 'leche (3,5% grasa)', 'Milch (3,5% Fett)', 2.0, 'cdas', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('4291ab6c-3d0f-4597-b12c-01a37f4a26b0', 'df37368c-dd71-4e2d-9e54-465ef0e96c7d', 'sésamo', 'Sesam', 5.0, 'cdas', 10);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('ab81d77f-bfc0-49d8-afce-37899a8c3452', 'cc9308e3-6331-48bc-b402-bf27dcbff18a', 'yogur (bajo en grasa)', 'Joghurt (fettarm)', 200.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('2644bdde-a113-4e2e-8ced-65ea5fa9b5f2', 'cc9308e3-6331-48bc-b402-bf27dcbff18a', 'frambuesas', 'Himbeeren', 50.0, 'g', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('f19f3f03-3217-45f0-b0d6-bcb62c70cc0c', 'cc9308e3-6331-48bc-b402-bf27dcbff18a', 'moras', 'Brombeeren', 50.0, 'g', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('17e14e7f-7d0e-47be-a5e9-e65a0c74286d', 'cc9308e3-6331-48bc-b402-bf27dcbff18a', 'semillas de chía', 'Chia Samen', 1.0, 'cda', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('67ef2fb6-9822-4854-b7cd-a3e8ff5f7ca3', 'cc9308e3-6331-48bc-b402-bf27dcbff18a', 'semillas de calabaza', 'Kürbiskerne', 2.0, 'cdta', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('5f9be2c3-11a0-4534-a6ca-8c2307338275', 'cc9308e3-6331-48bc-b402-bf27dcbff18a', 'semillas de girasol', 'Sonnenblumenkerne', 2.0, 'cdta', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('c0367251-6c16-4cb5-a663-b9296cc1d17d', 'cc9308e3-6331-48bc-b402-bf27dcbff18a', 'bayas de goji', 'Goji Beeren', 2.0, 'cdta', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('890138c5-6be7-46f5-bddd-aa4039395c62', 'cc9308e3-6331-48bc-b402-bf27dcbff18a', 'imón', 'Zitrone', 0.5, 'l', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('bf43cb24-58dc-47d9-b78f-1c69f377e454', '2ba2b2be-6ede-4b3e-b87f-b80a8c9f25f2', 'huevos', 'Eier', 2.0, '', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('4dbf33b4-8b73-4e4e-a4d4-c0d0ceca83b1', '2ba2b2be-6ede-4b3e-b87f-b80a8c9f25f2', 'claras de huevo', 'Eiweiß', 4.0, '', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('897db488-bc1e-4d11-a5bb-93fc593a25a1', '2ba2b2be-6ede-4b3e-b87f-b80a8c9f25f2', 'espinacas', 'Spinat', 50.0, 'g', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('31ffd31b-b407-4c57-b95e-45a4152e4f24', '2ba2b2be-6ede-4b3e-b87f-b80a8c9f25f2', 'mantequilla', 'Butter', 1.0, 'cdta', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('9619d7f3-7dbe-477b-adb7-d1614115bd8e', '2ba2b2be-6ede-4b3e-b87f-b80a8c9f25f2', 'cebolleta', 'Frühlingszwiebel', 1.0, '', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('e5925d77-0a0f-40d8-a9ab-93ba749b1534', '2ba2b2be-6ede-4b3e-b87f-b80a8c9f25f2', 'tomates cherry', 'Cherrytomaten', 100.0, 'g', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('d1625287-867a-4656-8d32-f70c5e0038ee', '2ba2b2be-6ede-4b3e-b87f-b80a8c9f25f2', 'sal', 'Salz', 0.333, 'cdta', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('01a44a2b-3855-44ec-9590-9d4c91c5a020', '2ba2b2be-6ede-4b3e-b87f-b80a8c9f25f2', 'pimienta', 'Pfeffer', 0.333, 'cdta', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('d0d61ad3-8126-4e89-94a5-6820c7b433ec', '16103d3d-a772-49cf-a9e0-3028cb4bb56a', 'huevos', 'Eier', 2.0, '', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('00a9003c-e43a-4e31-9af1-f270db0f1c9f', '16103d3d-a772-49cf-a9e0-3028cb4bb56a', 'onchas de bacon (50g)', 'Streifen Bacon (50g)', 2.0, 'l', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('f6a4948e-e539-4579-ba82-00d4db46f4b3', '16103d3d-a772-49cf-a9e0-3028cb4bb56a', 'aceite de oliva', 'Olivenöl', 1.0, 'cdta', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('95ba0c00-e5d5-42d7-9731-e2b360cd9a2c', '16103d3d-a772-49cf-a9e0-3028cb4bb56a', 'tomates', 'Tomaten', 150.0, 'g', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('082b5b5f-8533-49bc-a33f-8f394f271c3f', '16103d3d-a772-49cf-a9e0-3028cb4bb56a', 'sal', 'Salz', 0.25, 'cdta', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('282501ef-2f16-496d-925a-5a3a2f7f8621', '16103d3d-a772-49cf-a9e0-3028cb4bb56a', 'pimienta', 'Pfeffer', 0.25, 'cdta', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('aeae2feb-54e2-4260-a004-c49fbcd2d0e5', '49457d2a-8a02-40de-9816-f1ac3c9ac5a9', 'huevos', 'Eier', 2.0, '', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('04c8f54c-3033-45c1-9587-8c4db19da4b4', '49457d2a-8a02-40de-9816-f1ac3c9ac5a9', 'claras de huevo', 'Eiklar', 4.0, '', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('abb5e96a-1001-4ac8-a401-6c296434f307', '49457d2a-8a02-40de-9816-f1ac3c9ac5a9', 'mantequilla', 'Butter', 1.0, 'cdta', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('2c3103ae-48a9-40ae-aa2d-458635530ad1', '49457d2a-8a02-40de-9816-f1ac3c9ac5a9', 'sal', 'Salz', 0.333, 'cdta', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('1f9a61f6-330f-4bbf-a65f-90383f9cdda1', '49457d2a-8a02-40de-9816-f1ac3c9ac5a9', 'champiñones', 'Champignons', 150.0, 'g', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('fb900144-8f1d-40fa-9574-448156a66683', '49457d2a-8a02-40de-9816-f1ac3c9ac5a9', 'tomate', 'Tomate', 1.0, '', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('4db07e9c-b589-45db-9ee4-27afb988303e', '49457d2a-8a02-40de-9816-f1ac3c9ac5a9', 'pimienta', 'Pfeffer', 0.25, 'cdta', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('7db64e79-cdfe-4f94-b10c-3c5233b92cba', '49457d2a-8a02-40de-9816-f1ac3c9ac5a9', 'sal', 'Salz', 0.25, 'cdta', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('6dd11955-8aa4-4dc4-a497-0ed10fdbe948', '49457d2a-8a02-40de-9816-f1ac3c9ac5a9', 'mantequilla', 'Butter', 0.5, 'cdta', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('e730198c-ee02-4b2c-b089-6f8f12480a70', 'c0114175-58db-440b-a0c7-bae55af67582', 'yogur (bajo en grasa)', 'Joghurt (fettarm)', 200.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('adaf3407-ee0e-4ecf-977d-312397f924df', 'c0114175-58db-440b-a0c7-bae55af67582', 'arándanos', 'Blaubeeren', 100.0, 'g', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('ce6f18cd-0c72-4578-b9af-7e3623ff26cd', 'c0114175-58db-440b-a0c7-bae55af67582', 'semillas de chía', 'Chia Samen', 1.0, 'cda', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('3d112cb8-1fd3-48f5-a1cd-6c23b4f83926', 'c0114175-58db-440b-a0c7-bae55af67582', 'bayas de goji', 'Goji Beeren', 1.0, 'cda', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('ced067f0-8878-4e75-b252-11e4f3707aef', 'c0114175-58db-440b-a0c7-bae55af67582', 'almendras enteras', 'ganze Mandeln', 1.0, 'cda', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('e652a69c-639f-4825-800a-d65cd82a1eec', 'c0114175-58db-440b-a0c7-bae55af67582', 'imón', 'Zitrone', 0.5, 'l', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('eeced86f-9019-4f74-8a0f-6e6ee95355b9', '2d1ca448-ac09-44b4-8ce6-0f9374718dc1', 'huevos', 'Eier', 2.0, '', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('5b877b11-26d9-4134-9089-6b5da944813c', '2d1ca448-ac09-44b4-8ce6-0f9374718dc1', 'claras de huevo', 'Eiklar', 4.0, '', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('02b1ad30-0c58-48fa-ac85-cd639df0669b', '2d1ca448-ac09-44b4-8ce6-0f9374718dc1', 'pimiento (rojo)', 'Paprika (rot)', 0.5, '', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('0234fb9d-dea2-4343-aa19-89550ab95f01', '2d1ca448-ac09-44b4-8ce6-0f9374718dc1', 'pimiento (verde) Hidratos de carbono 10,7 g', 'Paprika (grün)', 0.5, '', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('312e5b58-4768-4614-9294-3a02ef60e45c', '2d1ca448-ac09-44b4-8ce6-0f9374718dc1', 'tomate', 'Tomate', 1.0, '', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('9abb1e5c-34d4-4045-b5eb-324cc9400ade', '2d1ca448-ac09-44b4-8ce6-0f9374718dc1', 'mantequilla', 'Butter', 1.0, 'cdta', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('cd76ce8d-257b-4313-b198-393b4c2764f5', '2d1ca448-ac09-44b4-8ce6-0f9374718dc1', 'sal', 'Salz', 0.5, 'cdta', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('d52ba44b-86e1-4450-bd69-2162672603ba', 'ff58d9b9-fa8b-443b-9e0e-b500de9a77ec', 'yogur (bajo en grasa)', 'Joghurt (fettarm)', 200.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('7c68f494-e80e-4db2-9f70-aba06df36a6b', 'ff58d9b9-fa8b-443b-9e0e-b500de9a77ec', 'frambuesas', 'Himbeeren', 50.0, 'g', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('d89111bf-33f2-42f3-b258-e668f8eeb8b7', 'ff58d9b9-fa8b-443b-9e0e-b500de9a77ec', 'arándanos', 'Blaubeeren', 50.0, 'g', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('da0acb93-1410-4fb9-8c8b-a62a852a5ead', 'ff58d9b9-fa8b-443b-9e0e-b500de9a77ec', 'coco rallado Hidratos de carbono 21,8 g', 'Kokosraspeln', 1.0, 'cda', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('5ccbbbe7-27a5-49fe-bdd4-c48770e50d4b', 'ff58d9b9-fa8b-443b-9e0e-b500de9a77ec', 'semillas de chía', 'Chia Samen', 1.0, 'cda', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('f9809272-95c2-4ce4-90f1-47e5e07e8ae9', 'ff58d9b9-fa8b-443b-9e0e-b500de9a77ec', 'imón', 'Zitrone', 0.5, 'l', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('07c4a011-99c3-4382-96d7-2c398b424b0e', '34c1fce1-bfc4-4501-9973-6051a87f6875', 'huevos', 'Eier', 2.0, '', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('2ad4ce7a-066d-4a42-8858-073d7d4ad15a', '34c1fce1-bfc4-4501-9973-6051a87f6875', 'claras de huevo', 'Eiklar', 2.0, '', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('68071752-c13f-45ff-b74a-cc7e2e278751', '34c1fce1-bfc4-4501-9973-6051a87f6875', 'queso (rallado)', 'Käse (gerieben)', 20.0, 'g', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('fa4d3549-f0f5-4042-b619-3599586471fc', '34c1fce1-bfc4-4501-9973-6051a87f6875', 'cebolletas Hidratos de carbono 11,8 g', 'Frühlingszwiebeln', 2.0, '', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('1632fc89-09f0-4824-95ec-c87331b0b12b', '34c1fce1-bfc4-4501-9973-6051a87f6875', 'leche (1,5% de grasa)', 'Milch (1,5% Fett)', 80.0, 'ml', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('bc43f7d2-c315-4309-a829-779749d805bb', '34c1fce1-bfc4-4501-9973-6051a87f6875', 'sal', 'Salz', 0.5, 'cdta', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('10beb8e9-2179-4642-9b14-cf71311956bf', '81d91094-afd1-4afd-b0eb-1133464af868', 'harina de almendras', 'Mandelmehl', 50.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('26416833-b76f-45ef-8f29-53618de364a4', '81d91094-afd1-4afd-b0eb-1133464af868', 'huevos', 'Eier', 2.0, '', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('aa008b55-d697-4fb6-b6e7-d06976fadc9c', '81d91094-afd1-4afd-b0eb-1133464af868', 'leche (1,5% de grasa)', 'Milch (1,5% Fett)', 80.0, 'ml', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('f04410a2-ad20-4246-a3a3-ce2f931428bd', '81d91094-afd1-4afd-b0eb-1133464af868', 'levadura en polvo', 'Backpulver', 0.5, 'cdta', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('2ef80feb-eebb-4c1c-8355-b9918d704a06', '81d91094-afd1-4afd-b0eb-1133464af868', 'otas de aroma de vainilla', 'Vanillearoma', 2.0, 'g', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('23242d05-d99e-4e69-92cf-3af7e7eacfae', '81d91094-afd1-4afd-b0eb-1133464af868', 'varias bayas', 'versch. Beeren', 0, '', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('5b298f14-7dbd-47e7-a024-9af05ac8b95b', '28550c68-dcb8-46c2-a18f-d2aa3dd424f7', 'harina de almendras', 'Mandelmehl', 50.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('83a386ad-9cb9-4e42-999a-991a4ebc68c6', '28550c68-dcb8-46c2-a18f-d2aa3dd424f7', 'huevo', 'Ei', 1.0, '', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('5ea3d352-ad70-462f-b110-84f4a79d8ca8', '28550c68-dcb8-46c2-a18f-d2aa3dd424f7', 'leche (1,5% de grasa)', 'Milch (1,5% Fett)', 50.0, 'ml', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('feea0289-1b2f-4d5f-8bd9-a22416a150a0', '28550c68-dcb8-46c2-a18f-d2aa3dd424f7', 'aceite de coco', 'Kokosöl', 1.0, 'cdta', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('d1fc9fcd-72a6-4a1f-8968-6b63a8855a89', '28550c68-dcb8-46c2-a18f-d2aa3dd424f7', 'levadura en polvo', 'Backpulver', 0.5, 'cdta', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('43fa6a19-ca31-41d7-a3c6-eb11e174271c', '28550c68-dcb8-46c2-a18f-d2aa3dd424f7', 'sal', 'Salz', 1.0, 'pizca', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('ace992a0-3791-4da4-b128-96707ae62b93', '28550c68-dcb8-46c2-a18f-d2aa3dd424f7', 'mantequilla', 'Butter', 1.0, 'cdta', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('2b8f9643-5534-4e49-9ef1-32ffe402b7f2', '28550c68-dcb8-46c2-a18f-d2aa3dd424f7', 'frambuesas', 'Himbeeren', 30.0, 'g', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('c110e643-7ae5-4ef8-9b1c-2e128ba2dbbb', '28550c68-dcb8-46c2-a18f-d2aa3dd424f7', 'arándanos', 'Blaubeeren', 30.0, 'g', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('a2a0a6c6-1c45-4cac-9dd4-84ad69f26adc', '28550c68-dcb8-46c2-a18f-d2aa3dd424f7', 'fresas', 'Erdbeeren', 30.0, 'g', 10);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('d8818142-ae94-452a-82a6-802a35afb0df', '145098a0-71eb-43ed-ab18-8f5f072ccd0d', 'huevo', 'Ei', 1.0, '', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('22700b05-a541-4645-a9b4-166c5afb894a', '145098a0-71eb-43ed-ab18-8f5f072ccd0d', 'claras de huevo', 'Eiklar', 4.0, '', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('79721d74-630b-49da-aab3-c99916c20376', '145098a0-71eb-43ed-ab18-8f5f072ccd0d', 'crème fraîche', 'Crème fraîche', 1.0, 'cda', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('557fbb32-ed33-4f09-b9eb-4ea77b8a2bc6', '145098a0-71eb-43ed-ab18-8f5f072ccd0d', 'oncha de bacon (35g)', 'Speck (35g)', 1.0, 'l', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('7117f1f0-d125-4d17-a7b7-c4651b510348', '145098a0-71eb-43ed-ab18-8f5f072ccd0d', 'tomate', 'Tomate', 1.0, '', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('48944582-9246-452f-958c-a8e3e1fdb82a', '145098a0-71eb-43ed-ab18-8f5f072ccd0d', 'agua', 'Wasser', 1.0, 'cda', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('0446ed8b-c735-4f6f-8c83-b8ad58c70c88', '145098a0-71eb-43ed-ab18-8f5f072ccd0d', 'cebolleta', 'Frühlingszwiebel', 1.0, '', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('5ba82703-3f7b-4b4e-ba1e-ef6b717da8f8', '145098a0-71eb-43ed-ab18-8f5f072ccd0d', 'sal', 'Salz', 0.25, 'cdta', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('c485d0c5-7c6c-4c4b-b501-e90f5654d385', '145098a0-71eb-43ed-ab18-8f5f072ccd0d', 'pimienta', 'Pfeffer', 0.25, 'cdta', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('15e5741b-3059-4683-b763-c56d7233c953', '145098a0-71eb-43ed-ab18-8f5f072ccd0d', 'mantequilla', 'Butter', 1.0, 'cdta', 10);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('2dc90ddc-ebf7-4939-8baf-29a665bf50d1', '1a02a9cd-beaf-4753-8a79-bf55901a5f56', 'harina de almendra', 'Mandelmehl', 50.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('fe3cdc59-87d8-435c-b693-c0f7489edc75', '1a02a9cd-beaf-4753-8a79-bf55901a5f56', 'leche (1,5% grasa)', 'Milch (1,5% Fett)', 100.0, 'ml', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('829f19b0-f82c-4f06-b87f-1a0cad27aae0', '1a02a9cd-beaf-4753-8a79-bf55901a5f56', 'huevo', 'Ei', 1.0, '', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('af62249e-a315-4976-af9a-6ad1b1b615a4', '1a02a9cd-beaf-4753-8a79-bf55901a5f56', 'clara de huevo', 'Eiklar', 1.0, '', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('cc1d4c69-c704-4ae9-a932-479d743b0861', '1a02a9cd-beaf-4753-8a79-bf55901a5f56', 'levadura en polvo', 'Backpulver', 0.5, 'cdta', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('41c22ed9-0d0c-4d6b-b858-dd343af641d6', '1a02a9cd-beaf-4753-8a79-bf55901a5f56', 'sal', 'Salz', 1.0, 'pizca', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('8b2d68d9-d4a5-4410-b49b-7c53fc4962f5', '1a02a9cd-beaf-4753-8a79-bf55901a5f56', 'mantequilla', 'Butter', 1.0, 'cdta', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('ab15454a-1960-4c1c-b787-3677eae7dbef', '1a02a9cd-beaf-4753-8a79-bf55901a5f56', 'arándanos', 'Blaubeeren', 60.0, 'g', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('c27307fd-8058-4dc8-bef9-dcd0e32526f2', '4c0c70ed-f329-4fbe-ab5a-02ac44f7c00d', 'huevos', 'Eier', 2.0, '', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('ca9a4032-444c-4134-9882-fe2f1788a3ff', '4c0c70ed-f329-4fbe-ab5a-02ac44f7c00d', 'claras de huevo', 'Eiklar', 2.0, '', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('5a83f860-c490-41a4-a13f-1c0624b4d68d', '4c0c70ed-f329-4fbe-ab5a-02ac44f7c00d', 'queso crema (doble crema)', 'Fischkäse (Doppelrahmstufe)', 50.0, 'g', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('834abf0c-3b6d-467c-b65a-6d8ce0e50275', '4c0c70ed-f329-4fbe-ab5a-02ac44f7c00d', 'levadura en polvo', 'Backpulver', 0.25, 'cdta', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('1e8d265e-48bd-4d81-ad58-583eb39b3961', '4c0c70ed-f329-4fbe-ab5a-02ac44f7c00d', 'sal', 'Salz', 1.0, 'pizca', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('c1ee3b5d-1ec4-4cdb-bc5e-ccf47d8c29c5', '7297ee6c-d839-4065-bca8-8eb8dd45cb93', 'huevo', 'Ei', 1.0, '', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('b617e757-0414-483e-987c-3b8b41d8c70a', '7297ee6c-d839-4065-bca8-8eb8dd45cb93', 'claras de huevo', 'Eiweiß', 4.0, '', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('9b13d124-9d4b-40aa-8843-9f9810d9be8b', '7297ee6c-d839-4065-bca8-8eb8dd45cb93', 'leche (1,5% de grasa)', 'Milch (1,5% Fett)', 50.0, 'ml', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('f290fc98-1172-4ba4-b045-b79619a19445', '7297ee6c-d839-4065-bca8-8eb8dd45cb93', 'tomates cherry', 'Cherrytomaten', 100.0, 'g', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('f163b80f-6164-4bde-9f93-40709d6207cc', '7297ee6c-d839-4065-bca8-8eb8dd45cb93', 'cebolleta', 'Frühlingszwiebel', 1.0, '', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('4d3a59f5-db96-4387-8433-05030a26a717', '7297ee6c-d839-4065-bca8-8eb8dd45cb93', 'sal', 'Salz', 0.25, 'cdta', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('eb7f631a-1cba-4c56-b550-38a5b3782cfc', '7297ee6c-d839-4065-bca8-8eb8dd45cb93', 'pimienta', 'Pfeffer', 0.25, 'cdta', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('7f5178ce-b896-42c2-8a61-428347b17038', '7297ee6c-d839-4065-bca8-8eb8dd45cb93', 'aceite de oliva', 'Olivenöl', 1.0, 'cda', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('3ad9dfab-53a7-4a09-9336-4f661898b249', 'c2733446-f02c-4770-be11-4e7b97c381db', 'huevos', 'Eier', 2.0, '', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('80f6f093-faa6-41b0-a869-6bc10a1d7fd4', 'c2733446-f02c-4770-be11-4e7b97c381db', 'claras de huevo', 'Eiweiß', 2.0, '', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('a209f34d-1cc9-4480-b6c4-e9a143f84fe7', 'c2733446-f02c-4770-be11-4e7b97c381db', 'sal Hidratos de carbono 11,2 g', 'Salz', 0.25, 'cdta', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('c97dd469-507a-4f06-9330-6dab9d055706', 'c2733446-f02c-4770-be11-4e7b97c381db', 'pimienta', 'Pfeffer', 0.25, 'cdta', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('2e29622e-0a67-49ba-8dbd-70170a1e2818', 'c2733446-f02c-4770-be11-4e7b97c381db', 'mantequilla', 'Butter', 1.0, 'cdta', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('084ef17b-4268-4081-b8c5-b927d1d48c84', 'c2733446-f02c-4770-be11-4e7b97c381db', 'calabacín', 'Zucchini', 0.5, '', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('612ba61e-1ed0-43d3-a202-0f8eeb4f907b', 'c2733446-f02c-4770-be11-4e7b97c381db', 'cebolla roja', 'rote Zwiebeln', 0.5, '', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('2ec17d13-e262-48b3-a4e6-c6e0a7b8a4ce', 'c2733446-f02c-4770-be11-4e7b97c381db', 'pimiento rojo', 'rote Paprika', 0.5, '', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('a85a973d-bdb2-4cf1-bea7-2c9ba9ba77c0', 'c2733446-f02c-4770-be11-4e7b97c381db', 'tomates', 'Tomaten', 50.0, 'g', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('0587be6d-8efb-4128-89b9-55bc8a9a3e21', 'c2733446-f02c-4770-be11-4e7b97c381db', 'aceitunas verdes (sin hueso)', 'grüne Oliven (entkernt)', 20.0, 'g', 10);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('aacf09b6-57bb-4896-8d6a-c567aa1d4ec1', 'c2733446-f02c-4770-be11-4e7b97c381db', 'champiñones', 'Champignons', 50.0, 'g', 11);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('335a48c0-a750-4695-9187-d317f413e372', 'c2733446-f02c-4770-be11-4e7b97c381db', 'Rúcula', 'Rucola', 0, '', 12);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('f971fa6c-08fa-4765-8944-7d519578c2a3', 'c2733446-f02c-4770-be11-4e7b97c381db', 'aceite de oliva', 'Olivenöl', 1.0, 'cdta', 13);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('f2a98788-02f8-493e-acc5-a54ea2910cf3', 'c2733446-f02c-4770-be11-4e7b97c381db', 'sal', 'Salz', 0.25, 'cdta', 14);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('de1167df-bf3f-4d31-bce7-bcd49776dded', 'c2733446-f02c-4770-be11-4e7b97c381db', 'pimienta', 'Pfeffer', 0.25, 'cdta', 15);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('8842ff54-e3c4-4e3e-a370-5bfe77200cf8', '42949dca-5609-42b9-928a-50e482fc71a0', 'huevos', 'Eier', 2.0, '', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('43c0de71-a44b-491b-8f64-2ddcd0f63d52', '42949dca-5609-42b9-928a-50e482fc71a0', 'claras de huevo', 'Eiklar', 3.0, '', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('e3516a10-e997-44b6-aa21-f42edcf804a0', '42949dca-5609-42b9-928a-50e482fc71a0', 'leche (1,5% de grasa) Hidratos de carbono 19,5 g', 'Milch (1,5% Fett)', 50.0, 'ml', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('30165a3f-eaec-4c12-affd-86c5888c4b68', '42949dca-5609-42b9-928a-50e482fc71a0', 'sal', 'Salz', 0.25, 'cdta', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('119aacb2-348e-4ea6-9f94-b04fec51259d', '42949dca-5609-42b9-928a-50e482fc71a0', 'mantequilla', 'Butter', 2.0, 'cdta', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('b50bb43d-9acf-47d1-85d0-2b1f2638ae0f', '42949dca-5609-42b9-928a-50e482fc71a0', 'judías verdes', 'grüne Bohnen', 80.0, 'g', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('7212e685-be27-47e4-9a46-28030bd9b6dd', '42949dca-5609-42b9-928a-50e482fc71a0', 'pimiento rojo', 'rote Paprika', 0.5, '', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('92caf158-150d-4bef-a838-7aee5672bb68', '42949dca-5609-42b9-928a-50e482fc71a0', 'pimiento amarillo', 'elbe Paprika', 0.5, 'g', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('8557e56d-8b2c-4a8e-979d-3c5371bdc621', '42949dca-5609-42b9-928a-50e482fc71a0', 'cebolla roja', 'rote Zwiebel', 0.5, '', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('b018b5e6-6996-4128-a790-290df50d6a7c', '42949dca-5609-42b9-928a-50e482fc71a0', 'tomates', 'Tomaten', 100.0, 'g', 10);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('7d953654-eedc-4945-a70e-04eca397f81f', '42949dca-5609-42b9-928a-50e482fc71a0', 'sal', 'Salz', 0.25, 'cdta', 11);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('f9a8ceea-3797-4424-bba1-b5fdf987ad3b', '42949dca-5609-42b9-928a-50e482fc71a0', 'pimienta', 'Pfeffer', 0.25, 'cdta', 12);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('b520371f-e56b-4caf-835b-82b11ef6c605', '42949dca-5609-42b9-928a-50e482fc71a0', 'aceite de oliva', 'Olivenöl', 1.0, 'cdta', 13);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('a754871b-fa71-459c-8d7f-9564e35c1632', 'bcc17229-94cd-451e-8db5-1beafa02c49f', 'queso quark desnatado', 'Magerquark', 100.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('a78ce46b-6c33-4863-9500-9812b5eeebd0', 'bcc17229-94cd-451e-8db5-1beafa02c49f', 'huevos', 'Eier', 2.0, '', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('7a1b44b9-59d3-48fb-8451-083898a0a4f7', 'bcc17229-94cd-451e-8db5-1beafa02c49f', 'proteína en polvo', 'Proteinpulver', 30.0, 'g', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('7293899e-71aa-4f87-a9e9-bc15689e50e8', 'bcc17229-94cd-451e-8db5-1beafa02c49f', 'leche (1,5% de grasa)', 'Milch (1.5% Fett)', 60.0, 'ml', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('0b02b94d-6a1c-4663-8475-aad3ad5d1181', 'bcc17229-94cd-451e-8db5-1beafa02c49f', 'mantequilla', 'Butter', 2.0, 'cdta', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('f06f8424-5cc7-4739-80f1-a72ba4959e6e', 'bcc17229-94cd-451e-8db5-1beafa02c49f', 'queso quark desnatado', 'Magerquark', 100.0, 'g', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('dcb42a05-bf75-4359-a7ef-71c07135c7b5', 'bcc17229-94cd-451e-8db5-1beafa02c49f', 'agua mineral', 'Mineralwasser', 1.0, 'cda', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('6c2a2af1-c740-435a-9405-5a4bfe1af2a1', 'bcc17229-94cd-451e-8db5-1beafa02c49f', 'edulcorante', 'Süßstoff', 1.0, 'cdta', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('a80112a7-6ff8-4082-8928-2f2dbdbf16ff', 'bcc17229-94cd-451e-8db5-1beafa02c49f', 'chorrito de zumo de limón', 'Spritzer Zitronensaft', 1.0, '', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('02917f61-eed7-401e-8b4d-80d4eb379f51', 'f1f9d9c2-8b20-4bd7-ae71-f5950adcb3dd', 'harina de almendra', 'Mandelmehl', 40.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('573532e1-34e5-409b-bab9-291f037fefbc', 'f1f9d9c2-8b20-4bd7-ae71-f5950adcb3dd', 'queso quark desnatado', 'Magerquark', 50.0, 'g', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('35dd59d0-c3a9-42c2-a14e-381b5a292f49', 'f1f9d9c2-8b20-4bd7-ae71-f5950adcb3dd', 'leche (1,5% de grasa)', 'Milch (1,5% Fett)', 50.0, 'ml', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('ae8f0ccc-9817-4435-9fae-2a3da61b7875', 'f1f9d9c2-8b20-4bd7-ae71-f5950adcb3dd', 'huevos', 'Eier', 2.0, '', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('432f695f-aa82-4e07-9066-70ca24b6ad9c', 'f1f9d9c2-8b20-4bd7-ae71-f5950adcb3dd', 'clara de huevo', 'Eiweiß', 1.0, '', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('be649c4c-0ac0-43c9-ad51-dab82cff01f3', 'f1f9d9c2-8b20-4bd7-ae71-f5950adcb3dd', 'proteína en polvo (vainilla)', 'Proteinpulver (Vanille)', 1.0, 'cda', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('ca577df5-b49e-4967-9bd2-e5e2a4591143', 'f1f9d9c2-8b20-4bd7-ae71-f5950adcb3dd', 'aceite de coco', 'Kokosöl', 2.0, 'cdta', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('3be10108-e96e-4bdc-bd59-30d18b8bb2bd', 'f1f9d9c2-8b20-4bd7-ae71-f5950adcb3dd', 'levadura en polvo', 'Backpulver', 0.5, 'cdta', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('64307d83-27cb-475b-9f59-1a129427da5a', 'c6d5b02a-da6b-44bf-b594-c0383422aab7', 'leche (1,5% de grasa)', 'Milch (1,5% Fett)', 100.0, 'ml', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('e2fe3be7-5081-400d-aa10-0d486652e9cb', 'c6d5b02a-da6b-44bf-b594-c0383422aab7', 'huevo', 'Ei', 1.0, '', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('2a75b661-606c-448f-b813-25698cc28311', 'c6d5b02a-da6b-44bf-b594-c0383422aab7', 'claras de huevo', 'Eiklar', 2.0, '', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('b01fd06d-adfe-4fee-9ae4-bbbdc1a2deb2', 'c6d5b02a-da6b-44bf-b594-c0383422aab7', 'harina de almendras', 'Mandelmehl', 30.0, 'g', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('04a54af3-abf9-4f78-b425-6b727e2f7091', 'c6d5b02a-da6b-44bf-b594-c0383422aab7', 'proteína en polvo (vainilla)', 'Proteinpulver (Vanille)', 20.0, 'g', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('edd7a3cc-727f-4083-a060-c78ed1091ce4', 'c6d5b02a-da6b-44bf-b594-c0383422aab7', 'levadura en polvo', 'Backpulver', 0.5, 'cucharadita', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('b94eca8d-58b6-49fe-aec5-af0cab871cb7', 'c6d5b02a-da6b-44bf-b594-c0383422aab7', 'sal', 'Salz', 1.0, 'pizca', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('7266d139-8041-48e3-9701-4163561154ef', 'c6d5b02a-da6b-44bf-b594-c0383422aab7', 'edulcorante', 'Süßstoff', 1.0, 'cucharada', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('17a8f8a9-c62b-4109-a0d5-35c30be0024e', 'c6d5b02a-da6b-44bf-b594-c0383422aab7', 'arándanos', 'Blaubeeren', 40.0, 'g', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('6164912d-ef67-4c0b-ac00-05eb7163c778', 'c6d5b02a-da6b-44bf-b594-c0383422aab7', 'mantequilla', 'Butter', 1.0, 'cucharadita', 10);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('033166bb-c8a8-413c-aef9-931150b44ab1', 'c6d5b02a-da6b-44bf-b594-c0383422aab7', 'arándanos', 'Blaubeeren', 40.0, 'g', 11);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('6b0322a2-8427-4976-a5fc-288701611694', 'c6d5b02a-da6b-44bf-b594-c0383422aab7', 'yogur (bajo en grasa)', 'Joghurt (fettarm)', 100.0, 'g', 12);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('9afc3c26-395e-4957-82a4-121b708619ea', 'c6d5b02a-da6b-44bf-b594-c0383422aab7', 'imón', 'Zitrone', 0.5, 'l', 13);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('6f6334bc-2797-4c6b-8b8c-4bfc4e38260e', '13651bdc-23b3-462f-9c17-2e67546881cf', 'harina de almendras', 'Mandelmehl', 50.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('dd913956-55e7-4c77-b83c-de5f56483780', '13651bdc-23b3-462f-9c17-2e67546881cf', 'huevo', 'Ei', 1.0, '', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('b2b8f89f-1f53-435d-b3e2-9698af73fe58', '13651bdc-23b3-462f-9c17-2e67546881cf', 'leche (1,5% de grasa)', 'Milch (1,5% Fett)', 30.0, 'ml', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('9a74f483-d63d-4cd8-a164-d6fbafc839f5', '13651bdc-23b3-462f-9c17-2e67546881cf', 'aceite de coco', 'Kokosöl', 0.5, 'cdta', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('22362692-cb52-46ee-8bd1-46e5b015ff3f', '13651bdc-23b3-462f-9c17-2e67546881cf', 'levadura en polvo', 'Msp. Backpulver', 1.0, 'pizca', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('37f3fcdd-6a01-4930-8caf-b9f372e4188f', '13651bdc-23b3-462f-9c17-2e67546881cf', 'sal', 'Salz', 1.0, 'pizca', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('a29df78b-b543-4df0-9bb1-ef84582aa72d', '13651bdc-23b3-462f-9c17-2e67546881cf', 'mantequilla', 'Butter', 1.0, 'cda', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('daad5ffb-9f8c-498d-95bc-9b64285cea06', '13651bdc-23b3-462f-9c17-2e67546881cf', 'frambuesas (congeladas)', 'Himbeeren (TK)', 80.0, 'g', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('462f4d02-a949-4025-ba64-9e0e56ffa108', '13651bdc-23b3-462f-9c17-2e67546881cf', 'imón', 'Zitrone', 0.5, 'l', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('e60ab3f9-1d5d-438a-829f-87476f3cda41', 'f5e50e91-33d0-428c-8455-3fd389d26153', 'harina de almendras', 'Mandelmehl', 60.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('879250ba-aa1e-4778-a852-dcc9eaaa46e0', 'f5e50e91-33d0-428c-8455-3fd389d26153', 'leche (1,5% de grasa)', 'Milch (1,5% Fett)', 40.0, 'ml', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('1537eee6-4fcf-4da4-b812-a49f818dd0ba', 'f5e50e91-33d0-428c-8455-3fd389d26153', 'huevo', 'Ei', 1.0, '', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('f44c5d69-99a7-4f9d-b01c-0441fe1de4da', 'f5e50e91-33d0-428c-8455-3fd389d26153', 'claras de huevo', 'Eiklar', 2.0, '', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('5cc6bdbc-1f53-4f8f-8346-7bdc3289ee8f', 'f5e50e91-33d0-428c-8455-3fd389d26153', 'levadura en polvo', 'Backpulver', 1.0, 'cdta', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('c1eafd42-fa94-40e4-9cf7-5a838797ccc3', 'f5e50e91-33d0-428c-8455-3fd389d26153', 'aceite', 'Öl', 1.0, 'cda', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('ac2a1aa9-2199-43e1-b981-675789cb63cf', 'b2d68271-2e92-4499-ae23-92ca8390e873', 'huevos', 'Eier', 2.0, '', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('8a097e30-6135-49ae-9d3f-df8ec5a915db', 'b2d68271-2e92-4499-ae23-92ca8390e873', 'claras de huevo', 'Eiweiß', 2.0, '', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('fceb4bca-1174-49cd-b679-7b854bd270a4', 'b2d68271-2e92-4499-ae23-92ca8390e873', 'pimiento rojo', 'rote Paprika', 0.5, '', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('90a47bd6-0c1e-4ae1-95c4-a8ddfbf47ad6', 'b2d68271-2e92-4499-ae23-92ca8390e873', 'calabacín', 'Zucchini', 0.5, '', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('429904c0-99a6-46ce-9f23-abb1b68a9a2e', 'b2d68271-2e92-4499-ae23-92ca8390e873', 'champiñones', 'Champignons', 80.0, 'g', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('80130ed8-5dab-41a8-b45f-a157bbad9ee5', 'b2d68271-2e92-4499-ae23-92ca8390e873', 'aceitunas negras (sin hueso)', 'schwarze Oliven (entkernt)', 20.0, 'g', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('82e9e7a1-1b40-4d2a-8275-214b8aec85a8', 'b2d68271-2e92-4499-ae23-92ca8390e873', 'cebolla roja', 'rote Zwiebel', 0.5, '', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('fc6ee08a-7896-4fed-9009-fe9011497202', 'b2d68271-2e92-4499-ae23-92ca8390e873', 'diente de ajo', 'Knoblauchzehe', 1.0, '', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('f925f710-52ba-4a13-bb7b-82ef7555ec74', 'b2d68271-2e92-4499-ae23-92ca8390e873', 'aceite de oliva', 'Olivenöl', 1.0, 'cucharada', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('5195dac0-207f-4f25-91f6-c8cb19877000', 'b2d68271-2e92-4499-ae23-92ca8390e873', 'sal', 'Salz', 0.25, 'cucharadita', 10);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('01c5290e-f529-4f85-9f80-8ecdea25f239', 'b2d68271-2e92-4499-ae23-92ca8390e873', 'pimienta', 'Pfeffer', 0.25, 'cucharadita', 11);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('dc9e731d-e6da-45d1-bbb8-40c68ff9c38c', 'b48ba79d-549b-470a-83c0-c56805385060', 'apio nabo', 'Knollensellerie', 150.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('cb2d1871-9ca5-4346-9e72-441018233cc5', 'b48ba79d-549b-470a-83c0-c56805385060', 'huevo', 'Ei', 1.0, '', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('1bd1f5e6-bc23-45b9-9a6e-9f9e548831b9', 'b48ba79d-549b-470a-83c0-c56805385060', 'queso quark desnatado', 'Magerquark', 60.0, 'g', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('5bc8bf2b-a128-4139-96a9-97a0e3242266', 'b48ba79d-549b-470a-83c0-c56805385060', 'aceite de oliva', 'Olivenöl', 2.0, 'cucharaditas', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('eaa57f2f-f937-4aae-81a6-1eb7a16f1080', 'b48ba79d-549b-470a-83c0-c56805385060', 'harina de algarroba', 'Johannisbrotkernmehl', 0.5, 'cucharadita', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('8fb02e02-700d-4d23-9ec0-7dbd21e18c76', 'b48ba79d-549b-470a-83c0-c56805385060', 'sal', 'Salz', 1.0, 'pizca', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('a355193e-1a66-4206-a4b6-8689e9fedc7c', 'b48ba79d-549b-470a-83c0-c56805385060', 'pimienta', 'Pfeffer', 1.0, 'pizca', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('5759cc08-83e6-476c-9c8e-95cda01a4239', 'b48ba79d-549b-470a-83c0-c56805385060', 'huevos', 'Eier', 2.0, '', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('2d163ad0-9614-4c3f-b8bf-71eda6fcbf0e', 'b48ba79d-549b-470a-83c0-c56805385060', 'aceite de oliva', 'Olivenöl', 0.5, 'cucharadita', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('3d8fa784-c7ff-4ae5-aea2-e8b815434bc9', 'b48ba79d-549b-470a-83c0-c56805385060', 'onchas de jamón cocido', 'Kochschinken', 2.0, 'l', 10);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('02fbad08-19ef-4139-a2d5-d14634322816', 'b48ba79d-549b-470a-83c0-c56805385060', 'Sal', 'Salz', 0, '', 11);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('9fbe4928-63ea-429b-a192-5a2e81424f1f', 'b48ba79d-549b-470a-83c0-c56805385060', 'Pimienta', 'Pfeffer', 0, '', 12);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('878cc22a-5592-4d06-9524-ed46abe3174a', '3c88f28a-8c81-440c-8fde-89f04c9740ad', 'champiñones', 'Champignons', 800.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('0721c556-7758-402d-919e-2945f037caab', '3c88f28a-8c81-440c-8fde-89f04c9740ad', 'cebolla', 'Zwiebel', 1.0, '', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('23ea7d66-ed97-4174-8f4c-ee9cb2385f32', '3c88f28a-8c81-440c-8fde-89f04c9740ad', 'dientes de ajo', 'Knoblauchzehen', 4.0, '', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('a1d02ec1-7d1d-4168-8f7f-50b6e469a965', '3c88f28a-8c81-440c-8fde-89f04c9740ad', 'aceite de oliva', 'Olivenöl', 6.0, 'cdas', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('83faba26-b8db-41b3-89f9-7039c60ca9a0', '3c88f28a-8c81-440c-8fde-89f04c9740ad', 'vinagre balsámico', 'Balsamico Essig', 1.0, 'cda', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('c0472e11-6ec8-400f-98a6-a99128a6c173', '3c88f28a-8c81-440c-8fde-89f04c9740ad', 'cdita de orégano (seco)', 'Oregano (getrocknet)', 1.0, 'TL', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('5a7e15bc-5632-4cfe-8ec3-df3295c398e3', '3c88f28a-8c81-440c-8fde-89f04c9740ad', 'perejil (picado)', 'Petersilie (gehackt)', 3.0, 'cdas', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('ce892399-f0ab-4c8f-83e1-b4e83d47c9a8', '3c88f28a-8c81-440c-8fde-89f04c9740ad', 'cdita de sal', 'Salz', 0.5, 'TL', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('d400057d-0100-4a16-9eb0-76a4d07883a6', '3c88f28a-8c81-440c-8fde-89f04c9740ad', 'cdita de pimienta', 'Pfeffer', 0.5, 'TL', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('4497cb98-21d2-4570-a64c-389cf44462c7', '3c88f28a-8c81-440c-8fde-89f04c9740ad', 'imón', 'Zitrone', 0.5, 'l', 10);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('4a539e4c-e7bd-4438-887e-4eaea4278aaf', 'cd763d4f-0fb4-4742-8f1a-3509ec6288ac', 'pimientos rojos', 'rote Paprika', 2.0, '', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('4395f28b-e4fa-45a5-8256-d26c97c9769f', 'cd763d4f-0fb4-4742-8f1a-3509ec6288ac', 'pimiento amarillo', 'elbe Paprika', 1.0, 'g', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('33847a23-ffc3-4471-867c-81c94e51b5c3', 'cd763d4f-0fb4-4742-8f1a-3509ec6288ac', 'pimiento verde', 'rüne Paprika', 1.0, 'g', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('d2b3f1c7-7134-4b79-a231-7aca0566f8ea', 'cd763d4f-0fb4-4742-8f1a-3509ec6288ac', 'alcaparras', 'Kapern', 2.0, 'cdas', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('06f6df18-d051-4d2a-8020-ccef8e22a4f8', 'cd763d4f-0fb4-4742-8f1a-3509ec6288ac', 'dientes de ajo', 'Knoblauchzehen', 2.0, '', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('254b7be5-5262-4888-ac56-d3ca0f48d264', 'cd763d4f-0fb4-4742-8f1a-3509ec6288ac', 'cdita de sal', 'Salz', 0.5, 'TL', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('937e4b4c-ef19-4987-ab77-6cb5caf30344', 'cd763d4f-0fb4-4742-8f1a-3509ec6288ac', 'cdita de pimienta', 'Pfeffer', 0.5, 'TL', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('c80472fb-41ca-4655-95ba-117cb741bac0', 'cd763d4f-0fb4-4742-8f1a-3509ec6288ac', 'cdita de pimentón en polvo', 'Paprikapulver', 0.5, 'TL', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('97bf8133-e6a3-450c-8d84-86e7c40d15f2', 'cd763d4f-0fb4-4742-8f1a-3509ec6288ac', 'aceite de oliva', 'Olivenöl', 3.0, 'cdas', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('473c5d7b-96a2-4d22-b044-d7fd11b3e421', 'cd763d4f-0fb4-4742-8f1a-3509ec6288ac', 'agua', 'Wasser', 100.0, 'ml', 10);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('02702537-6682-420c-9ba4-28c30d6dc39d', 'bd92450f-d2b7-4e32-a2e6-8edc8d9ed382', 'calabacines', 'Zucchini', 2.0, '', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('f10a155a-6b85-4d8f-a5cd-94b7958e0bb4', 'bd92450f-d2b7-4e32-a2e6-8edc8d9ed382', 'tomates', 'Tomaten', 5.0, '', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('962d33a5-35e6-4a16-8341-f4e28d493ecb', 'bd92450f-d2b7-4e32-a2e6-8edc8d9ed382', 'berenjenas', 'Auberginen', 2.0, '', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('873a06c9-fb4b-461c-881d-8b2504e6ce02', 'bd92450f-d2b7-4e32-a2e6-8edc8d9ed382', 'dientes de ajo', 'Knoblauchzehen', 2.0, '', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('b661f475-3710-4741-874d-0ea53d0229bf', 'bd92450f-d2b7-4e32-a2e6-8edc8d9ed382', 'aceite de oliva', 'Olivenöl', 3.0, 'cdas', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('cf3fa892-2e20-4bb7-9a69-4671eac8be7b', 'bd92450f-d2b7-4e32-a2e6-8edc8d9ed382', 'sal', 'Salz', 0.5, 'cdta', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('f4ad2f26-7a26-4b20-99e3-bc5c4ae46bc6', 'bd92450f-d2b7-4e32-a2e6-8edc8d9ed382', 'pimienta', 'Pfeffer', 0.5, 'cdta', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('7248f68b-f897-4071-9634-10af70bd6445', 'bd92450f-d2b7-4e32-a2e6-8edc8d9ed382', 'Albahaca', 'Basilikum', 0, '', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('c2009f7a-b3dd-416a-b89a-1ffcb30089f4', 'bd92450f-d2b7-4e32-a2e6-8edc8d9ed382', 'Tomillo', 'Thymian', 0, '', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('3e15c53b-b7b1-4148-8fbf-6ccfc8f77e88', 'c54d5491-0f65-455e-bae8-7c6fbff1df97', 'berenjenas', 'Auberginen', 4.0, '', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('9ae28d47-4afe-46b8-8fdc-4cb101315b5e', 'c54d5491-0f65-455e-bae8-7c6fbff1df97', 'tomates', 'Tomaten', 2.0, '', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('1a87d9b0-3324-4636-8a5d-265ee21c5cef', 'c54d5491-0f65-455e-bae8-7c6fbff1df97', 'pimiento amarillo', 'elbe Paprika', 1.0, 'g', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('d2c05f00-0e5e-4e72-8b70-58775b55d047', 'c54d5491-0f65-455e-bae8-7c6fbff1df97', 'pimiento rojo', 'rote Paprika', 1.0, '', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('939ff2fd-b35c-46f1-a9eb-92b168d85ec8', 'c54d5491-0f65-455e-bae8-7c6fbff1df97', 'cebolla', 'Zwiebel', 1.0, '', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('4b994220-0b69-4ed5-800b-087079d27095', 'c54d5491-0f65-455e-bae8-7c6fbff1df97', 'dientes de ajo', 'Knoblauchzehen', 2.0, '', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('f2d13500-1823-4740-90d1-26022b2b6826', 'c54d5491-0f65-455e-bae8-7c6fbff1df97', 'aceite de oliva', 'Olivenöl', 2.0, 'cdas', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('f0ad5c4b-dcdc-475f-9b00-a8eb0720343f', 'c54d5491-0f65-455e-bae8-7c6fbff1df97', 'sal', 'salz', 0.5, 'cdta', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('e2d5d967-3671-4a1f-8bd1-1cfb1d03d4f7', 'c54d5491-0f65-455e-bae8-7c6fbff1df97', 'pimienta', 'Pfeffer', 0.5, 'cdta', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('3840cc00-70c3-4b7f-8a44-2181b91f6fa3', '2ca7654c-1802-4efe-a9ef-f16f65a9d33c', 'calabacín (250g)', 'Zucchini (250g)', 1.0, '', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('0d9eb90b-d327-4953-aac1-47b11c443d36', '2ca7654c-1802-4efe-a9ef-f16f65a9d33c', 'berenjena (220g)', 'Aubergine (220g)', 1.0, '', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('479537ee-d585-4f38-80dc-bd542df247de', '2ca7654c-1802-4efe-a9ef-f16f65a9d33c', 'pimiento rojo', 'rote Paprika', 1.0, '', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('f51c2a88-cde3-4e6c-870b-a7330552bcb0', '2ca7654c-1802-4efe-a9ef-f16f65a9d33c', 'pimiento amarillo', 'elbe Paprika', 1.0, 'g', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('72d32df7-6534-4c3f-9031-ba7bc3acde6e', '2ca7654c-1802-4efe-a9ef-f16f65a9d33c', 'pimiento verde', 'rüne Paprika', 1.0, 'g', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('0a37ab58-30e4-4d2c-ae07-1d20191310b7', '2ca7654c-1802-4efe-a9ef-f16f65a9d33c', 'cebolla', 'Zwiebel', 1.0, '', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('b75b5c36-c474-45c9-9e05-6211f72fc43e', '2ca7654c-1802-4efe-a9ef-f16f65a9d33c', 'dientes de ajo', 'Knoblauchzehen', 2.0, '', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('688aa3ad-75dc-49cb-a111-7741ef52cd42', '2ca7654c-1802-4efe-a9ef-f16f65a9d33c', 'tomates', 'Tomaten', 3.0, '', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('336253d8-b040-47c2-91c1-37bb66541f3b', '2ca7654c-1802-4efe-a9ef-f16f65a9d33c', 'aceitunas verdes (sin hueso)', 'rüne Oliven (entkernt)', 12.0, 'G', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('046147b6-a0cf-4bec-85d2-b888741115ab', '2ca7654c-1802-4efe-a9ef-f16f65a9d33c', 'concentrado de tomate', 'Tomatenmark', 2.0, 'cucharadas', 10);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('4ece0b37-96cc-4856-831d-ee4a7d403901', '2ca7654c-1802-4efe-a9ef-f16f65a9d33c', 'caldo de verduras', 'Gemüsebrühe', 250.0, 'ml', 11);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('6b62670a-f9b4-4490-b5d6-013bf67bf112', '2ca7654c-1802-4efe-a9ef-f16f65a9d33c', 'aceite de oliva', 'Olivenöl', 3.0, 'cucharadas', 12);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('3bc1b791-21d3-4784-ac8a-6c398e330fd0', '2ca7654c-1802-4efe-a9ef-f16f65a9d33c', 'sal', 'Salz', 0.5, 'cucharadita', 13);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('5ffca891-ccee-47a9-9d2e-75afcab37b98', '2ca7654c-1802-4efe-a9ef-f16f65a9d33c', 'pimienta', 'Pfeffer', 0.5, 'cucharadita', 14);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('d9385d19-a05b-47eb-8206-3a3ff3851b77', '0a9c1c7b-23bf-4db0-bf33-f4c0862b75d2', 'pechuga de pollo', 'Hähnchenbrust', 500.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('70a50696-7963-424d-9725-29103f2ef8f7', '0a9c1c7b-23bf-4db0-bf33-f4c0862b75d2', 'tomates cherry', 'Cherrytomaten', 250.0, 'g', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('3f43f99c-a91f-4a88-bc50-6a125072489d', '0a9c1c7b-23bf-4db0-bf33-f4c0862b75d2', 'cebollas rojas', 'rote Zwiebeln', 2.0, '', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('3f72ba70-8e66-4cb3-a7da-d66a24dc04e8', '0a9c1c7b-23bf-4db0-bf33-f4c0862b75d2', 'dientes de ajo', 'Knoblauchzehen', 2.0, '', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('860acf03-3a75-4148-8b99-9c675724f09b', '0a9c1c7b-23bf-4db0-bf33-f4c0862b75d2', 'romero (seco)', 'Rosmarin (getrocknet)', 1.0, 'cucharadita', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('41c3b2b5-1db4-4264-9aa5-b8c3dc3cb5f1', '0a9c1c7b-23bf-4db0-bf33-f4c0862b75d2', 'sal', 'Salz', 0.5, 'cucharadita', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('6129cc7a-cd84-41ed-91b7-a7266deab7d2', '0a9c1c7b-23bf-4db0-bf33-f4c0862b75d2', 'pimienta', 'Pfeffer', 0.5, 'cucharadita', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('8be03b29-be17-4b9f-a1c8-04b8fbef033b', '0a9c1c7b-23bf-4db0-bf33-f4c0862b75d2', 'imón', 'Zitrone', 0.5, 'l', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('decf2eb8-8b38-4c86-9b93-7ef669f2e10d', '0a9c1c7b-23bf-4db0-bf33-f4c0862b75d2', 'aceite de oliva', 'Olivenöl', 1.0, 'cucharada', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('3411bff9-090f-45ec-95f2-149fd7a130f1', '0a9c1c7b-23bf-4db0-bf33-f4c0862b75d2', 'Albahaca', 'Basilikum', 0, '', 10);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('af6ac29a-517f-4372-b415-f3abd372dc7e', '302b35df-cc06-4ced-a788-84d58b4c8ace', 'coliflor grande', 'roßer Blumenkohl', 1.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('a34c9997-6989-44b0-be03-5721235b65e8', '302b35df-cc06-4ced-a788-84d58b4c8ace', 'parmesano (rallado)', 'Parmesan (gerieben)', 50.0, 'g', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('c3085140-4862-4377-9953-aa11f22869f0', '302b35df-cc06-4ced-a788-84d58b4c8ace', 'imón', 'Zitrone', 0.5, 'l', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('b7a90a7e-a266-4bee-9a2a-cc9eadbba6fa', '302b35df-cc06-4ced-a788-84d58b4c8ace', 'diente de ajo', 'Knoblauchzehe', 1.0, '', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('bd148856-595b-4280-8936-cbf227cc8a4a', '302b35df-cc06-4ced-a788-84d58b4c8ace', 'sal', 'Salz', 1.0, 'cdta', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('13c22a97-9d8b-468a-9249-2725deebfd7c', '302b35df-cc06-4ced-a788-84d58b4c8ace', 'pimienta', 'Pfeffer', 1.0, 'cdta', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('e0de59c8-6f8f-4d2c-bdba-7607effbfc81', '302b35df-cc06-4ced-a788-84d58b4c8ace', 'curry en polvo', 'Currypulver', 1.0, 'cdta', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('296463a7-8aff-41c5-9674-f4597945e88c', '302b35df-cc06-4ced-a788-84d58b4c8ace', 'aceite de oliva', 'Olivenöl', 4.0, 'cdas', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('64ead816-9b9e-4a95-afc3-de4bc27a820d', '302b35df-cc06-4ced-a788-84d58b4c8ace', 'agua', 'Wasser', 100.0, 'ml', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('6e3e161d-6b96-4648-bb7d-5a2fbaffb6cf', '059cd289-8bef-4e78-9061-c60582f69ad1', 'tomates cherry', 'Cherrytomaten', 1.0, 'kg', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('28966657-e165-415d-afea-e46ca7407ea2', '059cd289-8bef-4e78-9061-c60582f69ad1', 'aceite de oliva', 'Olivenöl', 6.0, 'cdas', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('4b8d7fbc-4faf-42a4-a03c-b044c9d946f4', '059cd289-8bef-4e78-9061-c60582f69ad1', 'dientes de ajo', 'Knoblauchzehen', 6.0, '', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('16888dcb-fef9-4604-87cd-8bca6bc8dfce', '059cd289-8bef-4e78-9061-c60582f69ad1', 'tomillo', 'Thymian', 2.0, 'cdas', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('f9d863f6-11ce-48d7-86ee-258f84cdb244', '059cd289-8bef-4e78-9061-c60582f69ad1', 'sal', 'Salz', 1.0, 'cdta', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('7b9668fa-b851-460c-97b9-86658a5c55b1', '059cd289-8bef-4e78-9061-c60582f69ad1', 'pimienta', 'Pfeffer', 0.5, 'cdta', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('6cbe1db0-1989-443f-bcf9-5e3a6314e617', 'ff952b86-05f0-4fa4-b4e4-5453493e4f35', 'filete de bacalao (4x 150g)', 'Dorschfilet (4x 150g)', 480.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('1dac2582-6496-43a0-9a79-a84d4be5474c', 'ff952b86-05f0-4fa4-b4e4-5453493e4f35', 'pimientos rojos', 'rote Paprika', 2.0, '', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('91b72ef7-1bda-428d-bffb-f0e558bab27b', 'ff952b86-05f0-4fa4-b4e4-5453493e4f35', 'pimientos amarillos', 'elbe Paprika', 2.0, 'g', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('8020667d-4e03-415b-8854-1359703c79a4', 'ff952b86-05f0-4fa4-b4e4-5453493e4f35', 'aceite de oliva', 'Olivenöl', 1.0, 'cda', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('fef87a33-24d5-480a-98df-d833e6d54507', 'ff952b86-05f0-4fa4-b4e4-5453493e4f35', 'mantequilla', 'Butter', 3.0, 'cdas', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('d6ffbaeb-8190-440b-8cb4-fc73208fb0ba', 'ff952b86-05f0-4fa4-b4e4-5453493e4f35', 'sal', 'Salz', 0.5, 'cdta', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('e46719d1-2443-40aa-883d-687e529721fb', 'ff952b86-05f0-4fa4-b4e4-5453493e4f35', 'pimienta', 'Pfeffer', 0.5, 'cdta', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('7ad4ae6b-b9b9-4bcb-8f71-a62a543d9370', 'ff952b86-05f0-4fa4-b4e4-5453493e4f35', 'pimentón en polvo', 'Paprikapulver', 0.5, 'cdta', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('b802b455-0baa-4b19-bae6-f080124e4b55', 'c4a8890e-e30f-46e5-adfd-04c997086f2c', 'calabacines (aprox. 900g)', 'Zucchini (ca. 900g)', 3.0, '', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('a6151d9b-556a-4e9d-b868-5a2166ff360b', 'c4a8890e-e30f-46e5-adfd-04c997086f2c', 'gambas (congeladas)', 'Garnelen (TK)', 500.0, 'g', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('b5abbe3a-33e6-4dbc-95c6-67e6d3850546', 'c4a8890e-e30f-46e5-adfd-04c997086f2c', 'dientes de ajo', 'Knoblauchzehen', 3.0, '', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('db4cd527-5628-431c-a7df-08635b4486bf', 'c4a8890e-e30f-46e5-adfd-04c997086f2c', 'aceite de oliva', 'Olivenöl', 3.0, 'cdas', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('402f19b2-36d8-43bc-8eb5-256fe55e9051', 'c4a8890e-e30f-46e5-adfd-04c997086f2c', 'tomates cherry', 'Kirschtomaten', 200.0, 'g', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('8cd81e66-5f77-4a33-b43f-fecdb661f835', 'c4a8890e-e30f-46e5-adfd-04c997086f2c', 'imones', 'Zitronen', 2.0, 'l', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('ba682b1a-d427-43d6-bb16-5f9a0d2de0c0', 'c4a8890e-e30f-46e5-adfd-04c997086f2c', 'sal', 'Salz', 1.0, 'cdta', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('af6bb0c9-c7f5-44c9-8782-29f9e820f452', 'c4a8890e-e30f-46e5-adfd-04c997086f2c', 'pimienta', 'Pfeffer', 0.5, 'cdta', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('7656c4c4-b6c2-4b97-82d5-331fe0873425', 'c4a8890e-e30f-46e5-adfd-04c997086f2c', 'agua', 'Wasser', 50.0, 'ml', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('c7daa1e1-04fd-4dbd-967b-f2ca4436f054', '37f9f6ec-c7c3-455f-b164-d7cee9cd78b6', 'calabacines', 'Zucchini', 4.0, '', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('f621374d-39dd-48f3-92a2-d021ed0fb01c', '37f9f6ec-c7c3-455f-b164-d7cee9cd78b6', 'tomates secos', 'getrocknete Tomaten', 200.0, 'g', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('86b34550-ea42-4b88-95e9-5a857fea9785', '37f9f6ec-c7c3-455f-b164-d7cee9cd78b6', 'aceite de oliva', 'Olivenöl', 4.0, 'cucharadas', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('10b0f2b8-a76e-4748-afe1-bece04fc79dd', '37f9f6ec-c7c3-455f-b164-d7cee9cd78b6', 'imón', 'Zitrone', 1.0, 'l', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('6e978e82-bdca-4066-b6cb-40a21d45f352', '37f9f6ec-c7c3-455f-b164-d7cee9cd78b6', 'sal', 'Salz', 0.5, 'cucharadita', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('f89617fa-e6b9-4e84-a3a3-2a6cf17af4ef', '37f9f6ec-c7c3-455f-b164-d7cee9cd78b6', 'pimienta', 'Pfeffer', 0.5, 'cucharadita', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('36196c3d-8f6c-4aa3-a3f8-a1a741ac9dc6', '37f9f6ec-c7c3-455f-b164-d7cee9cd78b6', 'mezcla de hierbas', 'Kräutermischung', 0.5, 'cucharadita', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('9519455e-b45b-4fa9-8504-c51e5f35a656', '37f9f6ec-c7c3-455f-b164-d7cee9cd78b6', 'queso (rallado)', 'Käse (gerieben)', 80.0, 'g', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('4b35af4b-0c80-4810-a68c-be1d3e29e8cd', 'b8d07be9-f11e-45d5-a8a4-32da34de9c65', 'pechuga de pollo', 'Hähnchenbrust', 400.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('0c9308a6-d236-4e5c-a1a4-e08cd8124d6c', 'b8d07be9-f11e-45d5-a8a4-32da34de9c65', 'feta', 'Feta', 100.0, 'g', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('47d24a91-13c5-4b16-98c8-96bf71fc1aa1', 'b8d07be9-f11e-45d5-a8a4-32da34de9c65', 'tomates', 'Tomaten', 250.0, 'g', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('c517cdcb-8144-44c4-a932-8204edd6d7fd', 'b8d07be9-f11e-45d5-a8a4-32da34de9c65', 'pepino', 'Salatgurke', 1.0, '', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('b9bd2c6d-8b2e-4980-88f6-9a3d562526b9', 'b8d07be9-f11e-45d5-a8a4-32da34de9c65', 'cebolla roja', 'rote Zwiebel', 1.0, '', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('749230c7-9adf-44fa-93b8-95da46095d4a', 'b8d07be9-f11e-45d5-a8a4-32da34de9c65', 'echuga', 'Kopfsalat', 1.0, 'l', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('51e12bc7-f000-4d3b-8289-ab0482b2526b', 'b8d07be9-f11e-45d5-a8a4-32da34de9c65', 'canonigos', 'Feldsalat', 200.0, 'g', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('bb90648a-fb7e-4455-8455-ae2b677d66ce', 'b8d07be9-f11e-45d5-a8a4-32da34de9c65', 'aceite de oliva', 'Olivenöl', 1.0, 'cucharada', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('823fd865-e5b8-4584-9783-1c0738868de3', 'b8d07be9-f11e-45d5-a8a4-32da34de9c65', 'aceite de oliva', 'Olivenöl', 4.0, 'cucharaditas', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('9c8af058-9f02-42a1-a71f-4b70dd0bf214', 'b8d07be9-f11e-45d5-a8a4-32da34de9c65', 'vinagre', 'Essig', 2.0, 'cucharadas', 10);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('43ccc27e-e21e-4883-87a7-1f2e28c9ddfe', 'b8d07be9-f11e-45d5-a8a4-32da34de9c65', 'imón', 'Zitrone', 0.5, 'l', 11);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('90b25213-a06e-4777-a1f7-119b93b281e4', 'b8d07be9-f11e-45d5-a8a4-32da34de9c65', 'sal', 'Salz', 0.333, 'cucharadita', 12);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('c87d64dc-df83-4941-81f8-d932a91f92c2', 'b8d07be9-f11e-45d5-a8a4-32da34de9c65', 'pimienta', 'Pfeffer', 0.333, 'cucharadita', 13);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('894c7680-2fb7-45c0-ba53-ec7009c818e4', '5fb7a249-04dc-4f75-9a8c-63afac1f1910', 'filete de salmón', 'Lachsfilet', 600.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('44c08707-d448-4563-a1ce-f264185cbd8f', '5fb7a249-04dc-4f75-9a8c-63afac1f1910', 'judías verdes', 'grüne Bohnen', 800.0, 'g', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('f0102571-02fd-4b6c-8a0e-ce72ab80190d', '5fb7a249-04dc-4f75-9a8c-63afac1f1910', 'zanahorias', 'Karotten', 4.0, '', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('9c263d88-410a-4c33-9fa8-87510fb3c42d', '5fb7a249-04dc-4f75-9a8c-63afac1f1910', 'sal', 'Salz', 0.5, 'cdta', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('f8e6eda0-e086-4817-8086-74f53ea806b8', '5fb7a249-04dc-4f75-9a8c-63afac1f1910', 'pimienta', 'Pfeffer', 0.5, 'cdta', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('441e4c70-02ea-423f-82fa-72dc5a815919', '5fb7a249-04dc-4f75-9a8c-63afac1f1910', 'mantequilla', 'Butter', 2.0, 'cdas', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('315d4203-656e-47a9-ba93-cd91efcb141f', '5fb7a249-04dc-4f75-9a8c-63afac1f1910', 'imón', 'Zitrone', 1.0, 'l', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('961f4259-ae6a-4695-a7b0-0f063e409854', '67d7608a-33fd-4039-8d01-c042f4247796', 'carne picada (ternera)', 'Hackfleisch (Rind)', 400.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('1f463544-70ed-4c33-90c5-632265cfee71', '67d7608a-33fd-4039-8d01-c042f4247796', 'tomates troceados (1/2 lata)', 'stückige Tomaten (1/2 Dose)', 250.0, 'g', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('8fad327c-3059-483e-be35-98223e95f13c', '67d7608a-33fd-4039-8d01-c042f4247796', 'maíz', 'Mais', 150.0, 'g', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('f75a31c6-bca8-4a56-87ef-aba73773e8d2', '67d7608a-33fd-4039-8d01-c042f4247796', 'alubias blancas', 'weiße Bohnen', 250.0, 'g', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('669785c7-911f-446d-b184-849389747101', '67d7608a-33fd-4039-8d01-c042f4247796', 'cebolla', 'Zwiebel', 1.0, '', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('483744e4-60d4-4c28-82be-b4d82b6197f6', '67d7608a-33fd-4039-8d01-c042f4247796', 'pimientos rojos', 'rote Paprika', 2.0, '', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('81275e9a-e22f-447b-b4ba-097ee00b3f60', '67d7608a-33fd-4039-8d01-c042f4247796', 'concentrado de tomate', 'Tomatenmark', 2.0, 'cdas', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('1f761590-2dd8-42de-9755-46c8cba530f1', '67d7608a-33fd-4039-8d01-c042f4247796', 'caldo', 'Brühe', 750.0, 'ml', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('e2e284dc-1e3f-400f-b6fe-8bd3d23af1b8', '67d7608a-33fd-4039-8d01-c042f4247796', 'aceite de oliva', 'Olivenöl', 1.0, 'cda', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('75bf0055-05b5-4388-ac82-400a259f8438', '67d7608a-33fd-4039-8d01-c042f4247796', 'sal', 'Salz', 0.5, 'cdta', 10);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('55630229-1e05-44c7-b4ab-db0739b233c6', '67d7608a-33fd-4039-8d01-c042f4247796', 'pimienta', 'Pfeffer', 0.5, 'cdta', 11);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('6892cb74-d776-4c42-95a3-22a62d4fecfe', '67d7608a-33fd-4039-8d01-c042f4247796', 'pimentón en polvo', 'Paprikapulver', 0.5, 'cdta', 12);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('8d1c6d36-eba6-4ad4-8d5f-558200d56090', 'e9de456a-f716-4c0d-804f-1a2e03be182f', 'calabacín', 'Zucchini', 800.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('b3503a3c-a7d0-4d18-b31e-441b37f48543', 'e9de456a-f716-4c0d-804f-1a2e03be182f', 'imón', 'Zitrone', 0.5, 'l', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('dbcf545b-cd47-4889-9d82-9128d65bfa1b', 'e9de456a-f716-4c0d-804f-1a2e03be182f', 'zanahorias', 'Karotten', 3.0, '', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('f391e415-0402-478d-acc8-c7c8c2ebbbfb', 'e9de456a-f716-4c0d-804f-1a2e03be182f', 'cebolla', 'Zwiebel', 1.0, '', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('d744a77d-2716-4e5d-b9ca-4dc253efbd7c', 'e9de456a-f716-4c0d-804f-1a2e03be182f', 'huevos', 'Eier', 4.0, '', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('85bfb418-ae2f-43c3-a52d-ed32f1377eab', 'e9de456a-f716-4c0d-804f-1a2e03be182f', 'queso (rallado)', 'Käse (gerieben)', 80.0, 'g', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('368e096f-4055-4197-9dff-6f85a30dddbb', 'e9de456a-f716-4c0d-804f-1a2e03be182f', 'sal', 'Salz', 0.5, 'cdta', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('36593f99-29e2-4395-a38d-dedf97d19dde', 'e9de456a-f716-4c0d-804f-1a2e03be182f', 'pimienta', 'Pfeffer', 0.5, 'cdta', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('938dd1f9-a275-4f86-bc96-398edc657a16', 'e9de456a-f716-4c0d-804f-1a2e03be182f', 'aceite de oliva', 'Olivenöl', 3.0, 'cdas', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('eba924dd-9e12-48b0-80b5-3b97c2df9b57', '94454096-6704-44cf-b13b-93fcb2fafda5', 'champiñones grandes', 'roße Champignons', 16.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('043ae932-0200-4c09-b8c4-a73ff2e5ebb3', '94454096-6704-44cf-b13b-93fcb2fafda5', 'espinacas (frescas)', 'Blattspinat (frisch)', 400.0, 'g', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('dc1537e0-6464-4e2f-addf-8e40eca92d8e', '94454096-6704-44cf-b13b-93fcb2fafda5', 'cebolla', 'Zwiebel', 1.0, '', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('3509cec7-8be4-4915-94cf-bd38cf9a8c64', '94454096-6704-44cf-b13b-93fcb2fafda5', 'dientes de ajo', 'Knoblauchzehen', 2.0, '', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('5e8706cc-5a63-4ddd-ac96-cea6ade91832', '94454096-6704-44cf-b13b-93fcb2fafda5', 'aceite de oliva', 'Olivenöl', 2.0, 'cdas', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('97893922-38e1-4186-a8d5-dbbe342283c9', '94454096-6704-44cf-b13b-93fcb2fafda5', 'nata', 'Sahne', 250.0, 'ml', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('881b66cd-e53d-4e8f-8db7-916a7a9d1426', '94454096-6704-44cf-b13b-93fcb2fafda5', 'queso (rallado)', 'Käse (gerieben)', 50.0, 'g', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('5c85f391-fd1d-49a4-8699-ba9db91e9f0a', '94454096-6704-44cf-b13b-93fcb2fafda5', 'sal', 'Salz', 0.5, 'cdta', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('3c1caccf-22d6-4f5e-8228-4df543ef87b9', '94454096-6704-44cf-b13b-93fcb2fafda5', 'pimienta', 'Pfeffer', 0.5, 'cdta', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('5d5d2ac8-dcae-465d-926c-10d34723656c', 'b92c26bb-5a07-464d-a0db-c3a1d263fbf1', 'coliflor', 'Blumenkohl', 800.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('0581919e-9cfc-46fb-a8ed-2de5194eaebe', 'b92c26bb-5a07-464d-a0db-c3a1d263fbf1', 'caldo de verduras', 'Gemüsebrühe', 200.0, 'ml', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('e74847cc-aa9e-4420-9699-049c949ec4a4', 'b92c26bb-5a07-464d-a0db-c3a1d263fbf1', 'huevos', 'Eier', 4.0, '', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('d96f4cd3-5e70-4ead-890a-edb358970f43', 'b92c26bb-5a07-464d-a0db-c3a1d263fbf1', 'leche (3,5% de grasa)', 'Milch (3,5% Fett)', 300.0, 'ml', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('852efcb4-b02c-4b22-a7e8-9646477eeaeb', 'b92c26bb-5a07-464d-a0db-c3a1d263fbf1', 'mantequilla', 'Butter', 1.0, 'cucharada', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('9503f303-4d6e-4cf4-88a4-03221af040f1', 'b92c26bb-5a07-464d-a0db-c3a1d263fbf1', 'queso (rallado)', 'Käse (gerieben)', 150.0, 'g', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('b060e19a-a4a2-4895-986b-29458bbe0da6', 'b92c26bb-5a07-464d-a0db-c3a1d263fbf1', 'sal', 'Salz', 0.5, 'cucharadita', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('0541d933-b6dd-4e29-8803-9c27888fe01d', 'b92c26bb-5a07-464d-a0db-c3a1d263fbf1', 'pimienta', 'Pfeffer', 0.5, 'cucharadita', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('a45855d8-57ec-4f2f-b9a7-845a951246d1', 'aeefdb45-d852-4c7f-9f41-39fda8fd8b22', 'rebozuelos', 'Pfifferlinge', 500.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('a889ac54-8639-45b8-a82f-56696a98898a', 'aeefdb45-d852-4c7f-9f41-39fda8fd8b22', 'cebolla', 'Zwiebel', 1.0, '', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('c2dd6b05-6dc2-4a3d-a915-618a57291410', 'aeefdb45-d852-4c7f-9f41-39fda8fd8b22', 'dientes de ajo', 'Knoblauchzehen', 2.0, '', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('415d8550-6125-4714-b2b5-2492872648b9', 'aeefdb45-d852-4c7f-9f41-39fda8fd8b22', 'aceite de oliva', 'Olivenöl', 2.0, 'cucharadas', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('10c75c3f-1ee3-428f-8d75-73f7c0a5d74b', 'aeefdb45-d852-4c7f-9f41-39fda8fd8b22', 'mantequilla', 'Butter', 2.0, 'cucharadas', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('41af8048-da56-465b-99bf-48ce2ef861e7', 'aeefdb45-d852-4c7f-9f41-39fda8fd8b22', 'nata para montar', 'Schlagsahne', 300.0, 'g', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('d803b878-b189-46c9-bcd7-b415e104bd72', 'aeefdb45-d852-4c7f-9f41-39fda8fd8b22', 'caldo de verduras', 'Gemüsebrühe', 400.0, 'ml', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('de01e8fe-b1eb-48a5-95be-081a3710549a', 'aeefdb45-d852-4c7f-9f41-39fda8fd8b22', 'sal', 'Salz', 0.5, 'cucharadita', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('eb3feaab-4f79-48b6-a187-84ab539859f2', 'aeefdb45-d852-4c7f-9f41-39fda8fd8b22', 'pimienta', 'Pfeffer', 0.5, 'cucharadita', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('9852fcc5-1240-4fe4-ae33-5387bceb5f8f', 'cd80e277-e341-4103-b46f-510f9948fa60', 'calabacín', 'Zucchini', 1.0, '', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('6d94395e-ab90-4170-94ec-ce0f3bf3eacd', 'cd80e277-e341-4103-b46f-510f9948fa60', 'huevos', 'Eier', 5.0, '', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('f17460c2-f9ee-449e-86c0-838a6f135c13', 'cd80e277-e341-4103-b46f-510f9948fa60', 'menta (picada)', 'Minze (gehackt)', 2.0, 'cdas', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('d18d040a-df17-4bbf-9cbc-6fc3457acd21', 'cd80e277-e341-4103-b46f-510f9948fa60', 'harina de coco', 'Kokosmehl', 80.0, 'g', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('69b0993f-6368-4d72-85b8-99e84d032f12', 'cd80e277-e341-4103-b46f-510f9948fa60', 'levadura en polvo', 'Backpulver', 0.5, 'cdta', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('50dd152d-33b2-422c-a240-c279347f5617', 'cd80e277-e341-4103-b46f-510f9948fa60', 'sal', 'Salz', 0.5, 'cdta', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('33c54454-3dfe-4bfd-b688-83500cdd9bf7', 'cd80e277-e341-4103-b46f-510f9948fa60', 'pimienta', 'Pfeffer', 0.5, 'cdta', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('024e0f97-79db-4300-bd43-5123179e0577', 'cd80e277-e341-4103-b46f-510f9948fa60', 'dientes de ajo', 'Knoblauchzehen', 2.0, '', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('68af9d07-ea0c-4f12-add3-a8f1a41ed9a2', 'cd80e277-e341-4103-b46f-510f9948fa60', 'onchas de queso (Gouda)', 'Käse (Gouda)', 6.0, 'l', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('47eb1618-1ca6-4f13-ad3f-9d1064cfbf79', 'cd80e277-e341-4103-b46f-510f9948fa60', 'onchas de jamón cocido', 'Kochschinken', 6.0, 'l', 10);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('529f5252-2a35-4e11-976f-071d56a1db85', '1933b541-be07-4b70-95b4-2a831a387d5e', 'brócoli', 'Brokkoli', 400.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('9580d765-7b3e-4e95-a62f-4e04fc05b3be', '1933b541-be07-4b70-95b4-2a831a387d5e', 'queso (rallado)', 'Käse (gerieben)', 150.0, 'g', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('b0907a69-6445-4881-b836-8fe62e192a25', '1933b541-be07-4b70-95b4-2a831a387d5e', 'huevos', 'Eier', 3.0, '', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('ff697b3a-9ec4-40f7-b04f-bea8b022b6ab', '1933b541-be07-4b70-95b4-2a831a387d5e', 'champiñones', 'Champignons', 150.0, 'g', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('7d9fab74-2f7e-4238-8fd7-77a47c6944c0', '1933b541-be07-4b70-95b4-2a831a387d5e', 'cebolla', 'Zwiebel', 1.0, '', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('88705a5a-5c03-4241-a69f-0d4b867ec064', '1933b541-be07-4b70-95b4-2a831a387d5e', 'cáscaras de psyllium', 'Flohsamenschalen', 30.0, 'g', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('4e35d42e-ad6f-4f8e-854c-e385e26b8a98', '1933b541-be07-4b70-95b4-2a831a387d5e', 'harina de linaza', 'Leinsamenmehl', 30.0, 'g', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('477edca8-0ef2-414b-b5fd-adb54816ef39', '1933b541-be07-4b70-95b4-2a831a387d5e', 'mostaza', 'Senf', 2.0, 'cdtas', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('667dc88b-bf55-4280-8605-dd67ac1d9572', '1933b541-be07-4b70-95b4-2a831a387d5e', 'aceite de oliva', 'Olivenöl', 3.0, 'cdas', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('f8b570ca-212f-460c-9f98-b0687f0ff37d', '1933b541-be07-4b70-95b4-2a831a387d5e', 'sal', 'Salz', 0.333, 'cdta', 10);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('0edb79b0-071a-474c-a1d0-d0714b6126e5', '1933b541-be07-4b70-95b4-2a831a387d5e', 'pimienta', 'Pfeffer', 0.333, 'cdta', 11);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('72dacd0f-744d-4c2f-8d1f-6e569411ba93', '89779823-d00e-4b3f-8ab9-837655d6d3bb', 'judías verdes', 'grüne Bohnen', 500.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('943ef6a6-49ae-4b3d-919d-7b82684a7a1d', '89779823-d00e-4b3f-8ab9-837655d6d3bb', 'pechuga de pollo', 'Hähnchenbrust', 400.0, 'g', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('aab5445b-2f0f-4753-b8a1-e537d6c9e3b3', '89779823-d00e-4b3f-8ab9-837655d6d3bb', 'champiñones', 'Champignons', 400.0, 'g', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('c1ea04e1-ce9c-43d7-9b75-e7d34e16cbdc', '89779823-d00e-4b3f-8ab9-837655d6d3bb', 'tomates cherry', 'Cherrytomaten', 150.0, 'g', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('0b2ec6f4-c2f6-4f2d-badf-9e1adda27e48', '89779823-d00e-4b3f-8ab9-837655d6d3bb', 'imón', 'Zitrone', 1.0, 'l', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('d13fc1be-14e5-4f1f-876c-c618f15fe526', '89779823-d00e-4b3f-8ab9-837655d6d3bb', 'dientes de ajo', 'Knoblauchzehen', 3.0, '', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('0fb31d79-4dc3-476b-965c-c7de065fdeab', '89779823-d00e-4b3f-8ab9-837655d6d3bb', 'cebolla', 'Zwiebel', 1.0, '', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('fea0b9eb-3fd8-48f6-a543-5f0b0f61a297', '89779823-d00e-4b3f-8ab9-837655d6d3bb', 'aceite de oliva', 'Olivenöl', 4.0, 'cucharadas', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('0215446a-6ae2-4fcb-babd-50c296b62b65', '89779823-d00e-4b3f-8ab9-837655d6d3bb', 'sal', 'Salz', 0.5, 'cucharadita', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('5d222c0d-0c59-46f2-b785-c517e0a0824d', '89779823-d00e-4b3f-8ab9-837655d6d3bb', 'pimienta', 'Pfeffer', 0.5, 'cucharadita', 10);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('5107ae09-0df0-460e-8200-540e8c19f37a', '89779823-d00e-4b3f-8ab9-837655d6d3bb', 'semillas de sésamo', 'Sesamsamen', 4.0, 'cucharaditas', 11);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('2617391f-c9fd-4f46-a3d6-8452540f88c1', 'd0c3701f-e3d6-4717-9671-c82e7df02835', 'filete de salmón (4x 200g)', 'Lachfilet (4x 200g)', 800.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('0c6f6f9c-68a7-4706-a3f7-488da961b635', 'd0c3701f-e3d6-4717-9671-c82e7df02835', 'pimientos amarillos', 'elbe Paprika', 2.0, 'g', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('80fba7e0-4c84-4631-9aff-28aea49cbec7', 'd0c3701f-e3d6-4717-9671-c82e7df02835', 'pimientos rojos', 'rote paprika', 2.0, '', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('327d9844-9495-49f4-9a18-7df0335ccb0d', 'd0c3701f-e3d6-4717-9671-c82e7df02835', 'pimientos verdes', 'rüne Paprika', 2.0, 'g', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('bd758fff-49b0-4944-8e7a-7c38a8ed8fc0', 'd0c3701f-e3d6-4717-9671-c82e7df02835', 'cebollas', 'Zwiebeln', 2.0, '', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('0bc4a69d-a17a-4983-b698-888c84ae3d47', 'd0c3701f-e3d6-4717-9671-c82e7df02835', 'diente de ajo', 'Knoblauchzehe', 1.0, '', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('220901f9-d64c-428c-b2ae-076dffd63818', 'd0c3701f-e3d6-4717-9671-c82e7df02835', 'caldo de verduras', 'Gemüsebrühe', 100.0, 'ml', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('f4d7124c-4837-4ede-8df6-814c49c25757', 'd0c3701f-e3d6-4717-9671-c82e7df02835', 'sal', 'Salz', 0.5, 'cdta', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('c6c52a38-f56f-41b5-b928-9d0db3feae3d', 'd0c3701f-e3d6-4717-9671-c82e7df02835', 'pimienta', 'Pfeffer', 0.5, 'cdta', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('68dd4ace-6200-40c1-8d4f-91471838651b', 'd0c3701f-e3d6-4717-9671-c82e7df02835', 'imón', 'Zitrone', 1.0, 'l', 10);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('14f28285-be81-4519-b86a-99dfb8971756', 'edf09f5d-f2b2-4a8b-b214-074eeafe749f', 'solomillo de cerdo', 'Schweinefilet', 500.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('b302da6e-8a85-4c50-8f92-4ba190a8e839', 'edf09f5d-f2b2-4a8b-b214-074eeafe749f', 'cebollas', 'Zwiebeln', 2.0, '', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('1974d800-1ae2-478b-9975-93690dfc0813', 'edf09f5d-f2b2-4a8b-b214-074eeafe749f', 'imones', 'Zitronen', 2.0, 'l', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('1ae67206-fd8a-418d-a009-be226b8ee8bc', 'edf09f5d-f2b2-4a8b-b214-074eeafe749f', 'sal', 'Salz', 0.5, 'cdta', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('1ec5c253-7ff3-4f5f-8842-1553c6a69444', 'edf09f5d-f2b2-4a8b-b214-074eeafe749f', 'pimienta', 'Pfeffer', 0.5, 'cdta', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('c7b02221-f2ff-463b-a934-38678370e205', 'edf09f5d-f2b2-4a8b-b214-074eeafe749f', 'semillas de sésamo', 'Sesamsamen', 2.0, 'cdta', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('2c7b6cdc-3528-4a39-bbb3-e5e256aaa362', '36c8ebfd-4c34-4e41-aa91-58e60f166f92', 'queso crema (doble crema)', 'Frischkäse (Doppelrahmstufe)', 150.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('d8f8d28a-a415-40e6-bc9f-be5aae1897ba', '36c8ebfd-4c34-4e41-aa91-58e60f166f92', 'harina de almendras', 'Mandelmehl', 50.0, 'g', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('2f0eef8a-3544-427e-ab42-6f59e54fa4a3', '36c8ebfd-4c34-4e41-aa91-58e60f166f92', 'huevos', 'Eier', 4.0, '', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('cc2229b2-91e8-4cb8-a70e-26fa2e097963', '36c8ebfd-4c34-4e41-aa91-58e60f166f92', 'parmesano (rallado)', 'Parmesan (gerieben)', 40.0, 'g', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('6554387d-3be7-4cb4-bc8c-b410c5af66df', '36c8ebfd-4c34-4e41-aa91-58e60f166f92', 'levadura en polvo', 'Backpulver', 1.0, 'cdta', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('bfda1e47-02b5-4687-b4a3-1d965424ba13', '36c8ebfd-4c34-4e41-aa91-58e60f166f92', 'tomates troceados (2 latas)', 'stückige Tomaten (2 Dosen)', 800.0, 'g', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('e11aa795-2db6-492d-aa92-773895f60e3e', '36c8ebfd-4c34-4e41-aa91-58e60f166f92', 'champiñones', 'Champignons', 250.0, 'g', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('af40652f-dc14-4249-bed3-c5b62ed3296a', '36c8ebfd-4c34-4e41-aa91-58e60f166f92', 'pimiento amarillo', 'elbe Paprika', 1.0, 'g', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('531cb0ea-94c4-4dea-a646-eb4f48b17c17', '36c8ebfd-4c34-4e41-aa91-58e60f166f92', 'pimiento rojo', 'rote Paprika', 1.0, '', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('9e965171-f3ee-4a41-9833-9879373d05e1', '36c8ebfd-4c34-4e41-aa91-58e60f166f92', 'pimiento verde', 'rüne Paprika', 1.0, 'g', 10);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('26d54863-8451-4372-84d3-24f351c75274', '36c8ebfd-4c34-4e41-aa91-58e60f166f92', 'cebolla', 'Zwiebel', 1.0, '', 11);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('dcbbb1a7-a453-422b-afea-c9ac0c05bc91', '36c8ebfd-4c34-4e41-aa91-58e60f166f92', 'aceite de oliva', 'Olivenöl', 2.0, 'cdas', 12);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('5c0824e8-3f71-4b7a-9dcb-3403a8674971', '36c8ebfd-4c34-4e41-aa91-58e60f166f92', 'concentrado de tomate', 'Tomatenmark', 4.0, 'cdas', 13);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('7be512e3-516a-4c8c-b5be-80f97d35f7ba', '36c8ebfd-4c34-4e41-aa91-58e60f166f92', 'queso (rallado)', 'Käse (gerieben)', 60.0, 'g', 14);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('62bf5744-800f-48b8-b24f-a37084f6c418', '36c8ebfd-4c34-4e41-aa91-58e60f166f92', 'sal', 'Salz', 0.5, 'cdta', 15);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('1e55346b-12a7-4f79-9666-64568fad3f16', '36c8ebfd-4c34-4e41-aa91-58e60f166f92', 'pimienta', 'Pfeffer', 0.5, 'cdta', 16);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('824f70d7-9f3e-4cc8-b5fc-811c2e1f1f4f', 'b053565d-a615-4b24-bc00-ce4a210afe03', 'berenjenas', 'Auberginen', 4.0, '', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('b12947df-9756-4d7d-9cec-73458d9a1f3e', 'b053565d-a615-4b24-bc00-ce4a210afe03', 'carne picada (ternera)', 'Hackfleisch (Rind)', 400.0, 'g', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('ab6dfe19-c334-46c2-84d3-fbf519c04463', 'b053565d-a615-4b24-bc00-ce4a210afe03', 'cebolla', 'Zwiebel', 1.0, '', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('9e1baeda-9dcb-4b62-8abc-9c9f2bf8047b', 'b053565d-a615-4b24-bc00-ce4a210afe03', 'dientes de ajo', 'Knoblauchzehen', 2.0, '', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('d4f413e6-51fe-45de-9713-751145600a1b', 'b053565d-a615-4b24-bc00-ce4a210afe03', 'tomates troceados (1 lata)', 'stückige Tomaten (1 Dose)', 400.0, 'g', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('68ff8639-852d-4c23-a4d5-635b8bc0ead3', 'b053565d-a615-4b24-bc00-ce4a210afe03', 'concentrado de tomate', 'Tomatenmark', 2.0, 'cucharadas', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('966c0150-72a2-4363-a859-e808b0837f8b', 'b053565d-a615-4b24-bc00-ce4a210afe03', 'sal', 'Salz', 0.5, 'cucharadita', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('1737acce-961d-4124-83c4-0974463cf81f', 'b053565d-a615-4b24-bc00-ce4a210afe03', 'pimienta', 'Pfeffer', 0.5, 'cucharadita', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('b9525b9a-1dda-4284-953e-c5f342816223', 'b053565d-a615-4b24-bc00-ce4a210afe03', 'pimentón', 'Paprikapulver', 0.5, 'cucharadita', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('4d385f4a-1f43-4329-a4e2-d4ee5adc937a', 'b053565d-a615-4b24-bc00-ce4a210afe03', 'imón', 'Zitrone', 1.0, 'l', 10);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('b96f5581-8031-4c8a-ba0d-32cda94af909', 'b053565d-a615-4b24-bc00-ce4a210afe03', 'aceite de oliva', 'Olivenöl', 2.0, 'cucharadas', 11);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('2dd42585-fbd3-40bd-bcce-d0bc6739e1f8', '31cadd74-8646-4ed4-a11c-735c0fd1631f', 'pechuga de pollo', 'Hähnchenbrust', 800.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('9b4d5180-91c0-4c5d-8fd5-e9f143dfc52a', '31cadd74-8646-4ed4-a11c-735c0fd1631f', 'brócoli', 'Brokkoli', 800.0, 'g', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('f98738a2-9f09-44c2-b730-0480534206e6', '31cadd74-8646-4ed4-a11c-735c0fd1631f', 'coles de Bruselas', 'Rosenkohl', 500.0, 'g', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('842bb89d-d42a-45ce-9671-64a04f1d7dfe', '31cadd74-8646-4ed4-a11c-735c0fd1631f', 'zanahorias baby', 'Babykarotten', 250.0, 'g', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('86c7bf7d-1ada-4bad-928b-8a36a2724416', '31cadd74-8646-4ed4-a11c-735c0fd1631f', 'pimientos (rojos)', 'Paprika (rot)', 2.0, '', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('254a686b-7fa4-4648-9d00-b7b94e9ad977', '31cadd74-8646-4ed4-a11c-735c0fd1631f', 'aceite de oliva', 'Olivenöl', 1.0, 'cucharada', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('4e09346b-3054-404a-8d01-2c3c0e400a1e', '31cadd74-8646-4ed4-a11c-735c0fd1631f', 'sal', 'Salz', 0.5, 'cucharadita', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('d37c137c-fe3d-4ce6-9f46-c5e1d0b06e7f', '31cadd74-8646-4ed4-a11c-735c0fd1631f', 'pimienta', 'Pfeffer', 0.5, 'cucharadita', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('21da9d16-7337-47f3-b826-535fe9d76511', '0017cd6c-0e51-4614-9d2c-d089fad2abb2', 'pechuga de pavo (4x 200g)', 'Putenbrust (4x 200g)', 800.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('76b3f4cb-4e09-41fe-a130-90f06a32c57e', '0017cd6c-0e51-4614-9d2c-d089fad2abb2', 'brócoli', 'Brokkoli', 800.0, 'g', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('681f6e34-09fa-49bd-83b1-eb1d24f73f6f', '0017cd6c-0e51-4614-9d2c-d089fad2abb2', 'zanahorias', 'Karotten', 2.0, '', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('a5b6650b-bb67-4cc7-ab55-b22f0bbe59e2', '0017cd6c-0e51-4614-9d2c-d089fad2abb2', 'maíz (en lata)', 'Mais (aus der Dose)', 150.0, 'g', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('79e83165-d592-42e0-9a55-e1fb5b21f56c', '0017cd6c-0e51-4614-9d2c-d089fad2abb2', 'pimientos rojos', 'rote Paprika', 2.0, '', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('391297b5-3794-4550-9bc4-88fe93eea7aa', '0017cd6c-0e51-4614-9d2c-d089fad2abb2', 'aceite de oliva', 'Olivenöl', 1.0, 'cucharada', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('7e0a9d87-c2e4-4b81-917c-501895cfdd53', 'a45cc207-8083-4996-9ffa-02eb0df629ca', 'calabacines', 'Zucchini', 4.0, '', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('c198354c-918d-415e-8b6e-7ba6ebdf4caf', 'a45cc207-8083-4996-9ffa-02eb0df629ca', 'carne picada (ternera)', 'Hackfleisch (Rind)', 500.0, 'g', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('e3403d02-3d99-4628-96b7-28e448f747ea', 'a45cc207-8083-4996-9ffa-02eb0df629ca', 'tomate concentrado', 'Tomatenmark', 4.0, 'cucharadas', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('ce7ffbf9-9793-470e-9dee-b5e4bc5d6941', 'a45cc207-8083-4996-9ffa-02eb0df629ca', 'queso feta', 'Schafskäse', 100.0, 'g', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('70d02e2e-d4ad-48f5-9991-e9fc901b3d7f', 'a45cc207-8083-4996-9ffa-02eb0df629ca', 'cebollas', 'Zwiebeln', 2.0, '', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('c508d8f3-24c9-4d4b-9233-095c10a76b35', 'a45cc207-8083-4996-9ffa-02eb0df629ca', 'caldo de verduras', 'Gemüsebrühe', 100.0, 'ml', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('19954c3a-067e-47dd-9228-4f805d2fcafd', 'a45cc207-8083-4996-9ffa-02eb0df629ca', 'pimentón en polvo', 'Paprikapulver', 1.0, 'cucharada', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('b6fd0cc9-56fd-455b-83dc-4420264ee21e', 'a45cc207-8083-4996-9ffa-02eb0df629ca', 'dientes de ajo', 'Knoblauchzehen', 2.0, '', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('b37e97aa-6eea-4d5e-bcb1-f9bf0df0d633', 'a45cc207-8083-4996-9ffa-02eb0df629ca', 'sal', 'Salz', 0.5, 'cucharadita', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('b684dab6-ca94-4d78-aa73-ed57379fe350', 'a45cc207-8083-4996-9ffa-02eb0df629ca', 'pimienta', 'Pfeffer', 0.5, 'cucharadita', 10);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('c5dac6f0-dfb0-4879-b409-edd3c6881772', 'fac72df5-3174-40dd-9e9b-80dedd4dbb40', 'ternera para gulasch', 'Rindergulasch', 800.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('dbff6098-e401-4eff-8cdb-eeb03d02dbfc', 'fac72df5-3174-40dd-9e9b-80dedd4dbb40', 'cebollas', 'Zwiebeln', 2.0, '', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('40eeb4fd-c454-4128-8975-7bbc2e0c1b82', 'fac72df5-3174-40dd-9e9b-80dedd4dbb40', 'dientes de ajo', 'Knoblauchzehen', 2.0, '', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('7310bfd5-146b-436c-a551-a39e6b1a5b2a', 'fac72df5-3174-40dd-9e9b-80dedd4dbb40', 'pimientos rojos', 'rote Paprika', 2.0, '', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('e235695f-25a1-4835-b14e-ed11411a2cd2', 'fac72df5-3174-40dd-9e9b-80dedd4dbb40', 'pimiento amarillo', 'elbe Paprika', 1.0, 'g', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('8de808b1-3a74-4f32-9154-8847d0df98ca', 'fac72df5-3174-40dd-9e9b-80dedd4dbb40', 'tomate concentrado', 'Tomatenmark', 4.0, 'cucharadas', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('6967e612-6f10-46fd-8df5-557594fc3516', 'fac72df5-3174-40dd-9e9b-80dedd4dbb40', 'tomate triturado', 'passierte Tomaten', 150.0, 'g', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('b1c17d22-08c7-4b57-ad7e-1b4333ffb1ca', 'fac72df5-3174-40dd-9e9b-80dedd4dbb40', 'caldo de verduras', 'Gemüsebrühe', 250.0, 'ml', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('e5efb0dd-0164-4fbe-813e-f14e99e8178b', 'fac72df5-3174-40dd-9e9b-80dedd4dbb40', 'sal', 'Salz', 0.5, 'cucharadita', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('e1df5ca4-493a-4dbd-8a4c-094208dc665d', 'fac72df5-3174-40dd-9e9b-80dedd4dbb40', 'pimienta', 'Pfeffer', 0.5, 'cucharadita', 10);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('1f8dc33b-d0ef-4145-8734-99a4da2633f1', 'fac72df5-3174-40dd-9e9b-80dedd4dbb40', 'pimentón', 'Paprikapulver', 0.5, 'cucharadita', 11);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('18a2411b-2312-4793-a586-a7d0ca11878d', 'fac72df5-3174-40dd-9e9b-80dedd4dbb40', 'aceite de oliva', 'Olivenöl', 1.0, 'cucharada', 12);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('d70a3f4d-7d90-460f-92e2-b2beae44b21f', '167b9674-841b-4f82-9a56-8915d2c5ad43', 'filete de salmón (4x 200g)', 'Lachsfilet (4x 200g)', 800.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('c3bbe635-5936-48b7-9e41-8fd0276ede95', '167b9674-841b-4f82-9a56-8915d2c5ad43', 'pimiento (rojo)', 'Paprika (rot)', 1.0, '', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('addf556b-ce29-431d-b925-05e58354a34e', '167b9674-841b-4f82-9a56-8915d2c5ad43', 'pimiento (amarillo)', 'Paprika (gelb)', 1.0, '', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('4c32540c-c7ac-435d-a427-77ee0300db9f', '167b9674-841b-4f82-9a56-8915d2c5ad43', 'rúcula', 'Rucola', 100.0, 'g', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('22f07412-9411-456b-a1b8-c28c81996e5c', '167b9674-841b-4f82-9a56-8915d2c5ad43', 'tomates cherry', 'Cherrytomaten', 250.0, 'g', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('3400840b-b54c-426c-a534-ecd92a505f21', '167b9674-841b-4f82-9a56-8915d2c5ad43', 'calabacín', 'Zucchini', 400.0, 'g', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('c4a37b0d-8ea4-473d-8ad2-64bb7ddc7018', '167b9674-841b-4f82-9a56-8915d2c5ad43', 'sal', 'Salz', 0.5, 'cucharadita', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('58e35d57-dfbc-4c7d-88e9-8ec50331f248', '167b9674-841b-4f82-9a56-8915d2c5ad43', 'pimienta', 'Pfeffer', 0.5, 'cucharadita', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('e799b0fc-0075-4022-b230-15b5cad4af8d', '167b9674-841b-4f82-9a56-8915d2c5ad43', 'aceite de oliva', 'Olivenöl', 2.0, 'cucharadas', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('cec5477d-b469-48df-9a2e-333fd2b7eb69', '167b9674-841b-4f82-9a56-8915d2c5ad43', 'zumo de limón', 'Zitronensaft', 2.0, 'cucharaditas', 10);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('8cb87bf3-6eae-41c3-a84f-24a41eb47de5', '0ec0f39a-fd40-4c00-b126-e69871b2ff8e', 'filete de salmón (4x 200g)', 'Lachsfilet (4x 200g)', 800.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('5bb2e7a6-5253-4f5f-8e49-f54048829747', '0ec0f39a-fd40-4c00-b126-e69871b2ff8e', 'brócoli', 'Brokkoli', 800.0, 'g', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('e013c0e5-12de-49bb-a2c4-3d3591667890', '0ec0f39a-fd40-4c00-b126-e69871b2ff8e', 'zanahorias', 'Möhren', 3.0, '', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('e528b3e5-1de1-4a42-9bc4-1e2e4222a039', '0ec0f39a-fd40-4c00-b126-e69871b2ff8e', 'aceite de oliva', 'Olivenöl', 2.0, 'cucharadas', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('3b878737-5f81-41e6-84df-386015233da0', '0ec0f39a-fd40-4c00-b126-e69871b2ff8e', 'sal', 'Salz', 1.0, 'cucharadita', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('e404b7b6-adf0-4fc6-bf05-700b800dd009', '0ec0f39a-fd40-4c00-b126-e69871b2ff8e', 'pimienta', 'Pfeffer', 1.0, 'cucharadita', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('990ab18d-d86c-4bb9-95a3-beabc56690bc', '0ec0f39a-fd40-4c00-b126-e69871b2ff8e', 'imones', 'Zitronen', 2.0, 'l', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('c2e1f3f9-645c-4415-aead-150d654d891e', '0ec0f39a-fd40-4c00-b126-e69871b2ff8e', 'Romero', 'Rosmarin', 0, '', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('11034a38-e528-4e31-b286-9c5dc05dc49b', 'e0c3521f-349b-4c49-912d-a726e4c0ab2e', 'harina de almendra', 'Mandelmehl', 100.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('3c8ecedc-5a3a-42d2-b72a-e8fd4a93ca6e', 'e0c3521f-349b-4c49-912d-a726e4c0ab2e', 'huevos', 'Eier', 4.0, '', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('749cbdaf-c969-4578-bbeb-9dc6c0cfa41d', 'e0c3521f-349b-4c49-912d-a726e4c0ab2e', 'queso crema', 'Frischkäse', 50.0, 'g', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('221de78d-4373-4e39-89c1-cebfa9b3ec54', 'e0c3521f-349b-4c49-912d-a726e4c0ab2e', 'levadura en polvo', 'Backpulver', 0.5, 'cucharadita', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('b529f6dc-674a-41c3-a088-868a04552456', 'e0c3521f-349b-4c49-912d-a726e4c0ab2e', 'agua', 'Wasser', 2.0, 'cucharadas', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('a4895394-dccf-40d2-924d-c51f88686594', 'e0c3521f-349b-4c49-912d-a726e4c0ab2e', 'sal', 'Salz', 0.5, 'cucharadita', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('6d8cc559-ee7b-4769-8921-c016fcf7502e', 'e0c3521f-349b-4c49-912d-a726e4c0ab2e', 'mozzarella', 'Mozzarella', 120.0, 'g', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('baafd401-ccb2-4c65-b2bd-b8d18cef1603', 'e0c3521f-349b-4c49-912d-a726e4c0ab2e', 'queso (rallado)', 'Käse (gerieben)', 50.0, 'g', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('fba7c9cb-e848-4c84-baae-205f30032c73', 'e0c3521f-349b-4c49-912d-a726e4c0ab2e', 'pimientos rojos', 'rote Paprika', 2.0, '', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('fc7cee01-a7ad-412a-af72-562da56a4bdd', 'e0c3521f-349b-4c49-912d-a726e4c0ab2e', 'champiñones', 'Champignons', 200.0, 'g', 10);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('f73e7c7b-12c0-49f2-be64-30d029403f53', 'e0c3521f-349b-4c49-912d-a726e4c0ab2e', 'dientes de ajo', 'Knoblauchzehen', 2.0, '', 11);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('fb730d7a-df60-4375-bd59-fadc5980ae2d', 'e0c3521f-349b-4c49-912d-a726e4c0ab2e', 'aceite de oliva', 'Olivenöl', 2.0, 'cucharadas', 12);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('072671c9-b254-414f-a640-f6c38dc14c08', 'e7157dc1-85af-4080-9ca0-20e38cd26145', 'pechuga de pavo (4x 200g)', 'Putenbrust (4x 200g)', 800.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('dd1c4234-d30d-434f-9bc2-d5f5a25be1fd', 'e7157dc1-85af-4080-9ca0-20e38cd26145', 'brócoli', 'Brokkoli', 1.0, '', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('96c21aed-ce5e-4e83-85d2-b95cfd8f5011', 'e7157dc1-85af-4080-9ca0-20e38cd26145', 'zanahorias', 'Karotten', 4.0, '', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('81fc64fb-bbbe-40f1-b659-92079e29ad7f', 'e7157dc1-85af-4080-9ca0-20e38cd26145', 'dientes de ajo', 'Knoblauchzehen', 2.0, '', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('b8af1698-cc9f-4d76-a4ef-a08df034e261', 'e7157dc1-85af-4080-9ca0-20e38cd26145', 'aceite de oliva', 'Olivenöl', 3.0, 'cucharadas', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('9d616f60-6da8-46b4-b043-16296fe62260', 'e7157dc1-85af-4080-9ca0-20e38cd26145', 'sal', 'Salz', 0.5, 'cucharadita', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('198c3184-5c44-47ab-af69-93c33a2950ae', 'e7157dc1-85af-4080-9ca0-20e38cd26145', 'pimienta', 'Pfeffer', 0.5, 'cucharadita', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('5b34c7a3-558a-4a93-ab27-0a89bb692fd5', 'e7157dc1-85af-4080-9ca0-20e38cd26145', 'imón', 'Zitrone', 1.0, 'l', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('ea28e16a-804b-46d9-8542-49aceb4be274', 'a3a68aeb-dd35-4629-a40f-28c2650f82e8', 'carne picada (ternera)', 'Hackfleisch (Rind)', 500.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('c6a1eaec-4315-480c-bc8b-cea316370ff6', 'a3a68aeb-dd35-4629-a40f-28c2650f82e8', 'tomates', 'Tomaten', 4.0, '', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('75eabe1d-d577-4700-9d5d-4db2e452e4f7', 'a3a68aeb-dd35-4629-a40f-28c2650f82e8', 'cebolla', 'Zwiebel', 1.0, '', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('b13dc95a-3b94-4b48-833c-01a9d355b4aa', 'a3a68aeb-dd35-4629-a40f-28c2650f82e8', 'dientes de ajo', 'Knoblauchzehen', 3.0, '', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('3cc81f6b-5c07-4284-9844-21aa9c37b2d6', 'a3a68aeb-dd35-4629-a40f-28c2650f82e8', 'chile rojo', 'rote Chilischote', 1.0, '', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('75e51f5d-d763-44a6-ba0e-133dc4e9c895', 'a3a68aeb-dd35-4629-a40f-28c2650f82e8', 'alubias rojas', 'Kidneybohnen', 250.0, 'g', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('dd02b24f-d3d5-4569-825c-efed1e4dc17d', 'a3a68aeb-dd35-4629-a40f-28c2650f82e8', 'maíz', 'Mais', 200.0, 'g', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('f86955c9-e803-48bd-aeff-05d223eaa549', 'a3a68aeb-dd35-4629-a40f-28c2650f82e8', 'tomate triturado', 'passierte Tomaten', 200.0, 'ml', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('737778fd-0add-4838-b0aa-18dc4a0ff450', 'a3a68aeb-dd35-4629-a40f-28c2650f82e8', 'caldo de verduras', 'Gemüsebrühe', 200.0, 'ml', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('d57f9d6b-aac7-49b1-9713-d7a23a1f1ee0', 'a3a68aeb-dd35-4629-a40f-28c2650f82e8', 'sal', 'Salz', 0.5, 'cucharadita', 10);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('696ae2d1-7a68-4539-b89c-1a27cb4b911d', 'a3a68aeb-dd35-4629-a40f-28c2650f82e8', 'pimienta', 'Pfeffer', 0.5, 'cucharadita', 11);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('fb6c197d-271a-41db-9d30-d14bf59d581b', 'a3a68aeb-dd35-4629-a40f-28c2650f82e8', 'pimentón', 'Paprikapulver', 0.5, 'cucharadita', 12);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('daa776ee-a288-45ba-bfbf-e6d94e50e16d', 'a3a68aeb-dd35-4629-a40f-28c2650f82e8', 'aceite de oliva', 'Olivenöl', 1.0, 'cucharada', 13);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('6a70550e-ca51-4628-b3ab-a14b0876386d', 'a3a68aeb-dd35-4629-a40f-28c2650f82e8', 'Perejil', 'Petersilie', 0, '', 14);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('2a034390-0b4f-4d0f-9fec-db25f480f55d', '9ce828e9-daed-4320-be70-d7f25500fcbf', 'gambas (congeladas)', 'Garnelen (TK)', 500.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('d1d6adf5-3012-4e95-860c-2954949995b6', '9ce828e9-daed-4320-be70-d7f25500fcbf', 'huevos', 'Eier', 4.0, '', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('92dfc16d-8e13-4289-b6b0-c51659f6f5ad', '9ce828e9-daed-4320-be70-d7f25500fcbf', 'dientes de ajo', 'Knoblauchzehen', 4.0, '', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('767a6674-48b2-4883-9308-1220619192fc', '9ce828e9-daed-4320-be70-d7f25500fcbf', 'aceite de oliva', 'Olivenöl', 2.0, 'cucharadas', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('a4217e4c-82ec-4cf6-bdaf-3c5b83a8088c', '9ce828e9-daed-4320-be70-d7f25500fcbf', 'echuga frisée', 'Friseesalatkopf', 1.0, 'l', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('c3fbb50c-d5bb-44b0-a164-7ca0e9908fe6', '9ce828e9-daed-4320-be70-d7f25500fcbf', 'canónigos', 'Feldsalat', 250.0, 'g', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('d4e15f13-03bb-4d03-8788-51aa1cb3f4c9', '9ce828e9-daed-4320-be70-d7f25500fcbf', 'tomates cherry', 'Kirschtomaten', 200.0, 'g', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('61f6c853-55a5-48f5-b851-43f4a26df078', '9ce828e9-daed-4320-be70-d7f25500fcbf', 'imón', 'Zitrone', 1.0, 'l', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('ed0612ae-4231-4376-a3fc-a8e967ab67e2', '9ce828e9-daed-4320-be70-d7f25500fcbf', 'aceite de oliva', 'Olivenöl', 3.0, 'cucharadas', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('2a251747-7bb3-47aa-b992-da2b3d43b4d2', '9ce828e9-daed-4320-be70-d7f25500fcbf', 'sal', 'Salz', 0.333, 'cucharadita', 10);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('86977fbc-ed6a-42fc-a360-06e38d55765f', '9ce828e9-daed-4320-be70-d7f25500fcbf', 'pimienta', 'Pfeffer', 0.333, 'cucharadita', 11);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('5bddf32a-4108-4df3-b157-d15ef8a923ac', '9ce828e9-daed-4320-be70-d7f25500fcbf', 'chile en polvo', 'Chilipulver', 0.333, 'cucharadita', 12);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('ad4b25a4-d443-4ca6-92cc-af81b715f57a', '9ce828e9-daed-4320-be70-d7f25500fcbf', 'semillas de sésamo', 'Sesamsamen', 4.0, 'cucharaditas', 13);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('15e4705e-eef7-4a99-b2ce-8cb0ee4580d7', 'c1bc91d3-9d9e-444a-bf07-b6ad5a906d4f', 'calabaza (Hokkaido)', 'Kürbis (Hokkadio)', 800.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('34eafdeb-af57-47b2-906b-cf29db23cb94', 'c1bc91d3-9d9e-444a-bf07-b6ad5a906d4f', 'zanahorias', 'Möhren', 300.0, 'g', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('6fd041de-3543-4aa4-ba2a-d4ec0e76ecc6', 'c1bc91d3-9d9e-444a-bf07-b6ad5a906d4f', 'cebolla', 'Zwiebel', 1.0, '', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('e237182a-b283-48db-8c1b-52584a3d1d75', 'c1bc91d3-9d9e-444a-bf07-b6ad5a906d4f', 'dientes de ajo', 'Knoblauchzehen', 2.0, '', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('f278f9b6-a8c9-4789-8053-4e2fc32e41be', 'c1bc91d3-9d9e-444a-bf07-b6ad5a906d4f', 'trozo de jengibre (2cm)', 'Ingwerstück (2cm)', 1.0, '', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('7c11f1ce-5db8-4286-aade-d5ac9e40e04b', 'c1bc91d3-9d9e-444a-bf07-b6ad5a906d4f', 'mantequilla', 'Butter', 2.0, 'cucharadas', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('c1eeafa8-5d0e-438b-98f5-595425b315cb', 'c1bc91d3-9d9e-444a-bf07-b6ad5a906d4f', 'caldo de verduras', 'Gemüsebrühe', 1000.0, 'ml', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('523b218c-8fc7-454b-9b06-44bfa1cdda34', 'c1bc91d3-9d9e-444a-bf07-b6ad5a906d4f', 'leche de coco (lata)', 'Kokosmilch (Dose)', 400.0, 'ml', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('4a962e89-8d6e-419e-b195-74eb5f075095', 'c1bc91d3-9d9e-444a-bf07-b6ad5a906d4f', 'imón', 'Zitrone', 1.0, 'l', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('04a3da4d-3ce5-4f6b-adeb-12b4f67b8f2e', 'c1bc91d3-9d9e-444a-bf07-b6ad5a906d4f', 'curry en polvo', 'Currypulver', 0.5, 'cucharadita', 10);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('d2a0ef87-517f-480a-a225-d371d58b36f6', 'c1bc91d3-9d9e-444a-bf07-b6ad5a906d4f', 'sal', 'Salz', 0.5, 'cucharadita', 11);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('b4cce035-9c74-410b-a6ff-1a83ef72311b', 'c1bc91d3-9d9e-444a-bf07-b6ad5a906d4f', 'pimienta', 'Pfeffer', 0.5, 'cucharadita', 12);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('eaf23848-9ff9-45f0-8da1-bb0dc06ef606', 'c1bc91d3-9d9e-444a-bf07-b6ad5a906d4f', 'semillas de calabaza', 'Kürbiskerne', 4.0, 'cucharaditas', 13);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('2c643fe6-188b-4530-ae2a-81df8d61efa2', 'c1bc91d3-9d9e-444a-bf07-b6ad5a906d4f', 'crema agria', 'Saure Sahne', 4.0, 'cucharaditas', 14);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('13efce23-a030-4a80-bfce-4c47cd66443a', 'ab16650b-7a90-4398-853f-ce8b3ee9285e', 'carne picada de ternera', 'Rinderhackfleisch', 500.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('e4be45f0-3537-43f4-a671-eca89bfa9c07', 'ab16650b-7a90-4398-853f-ce8b3ee9285e', 'tomates', 'Tomaten', 300.0, 'g', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('9c5a18cc-f6b4-44fd-a25e-962478b214f9', 'ab16650b-7a90-4398-853f-ce8b3ee9285e', 'concentrado de tomate', 'Tomatenmark', 120.0, 'g', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('838a9ce1-b1d5-4906-9c29-0542a5cce142', 'ab16650b-7a90-4398-853f-ce8b3ee9285e', 'caldo de verduras', 'Gemüsebrühe', 600.0, 'ml', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('a675bb68-d7dd-4146-87d6-cda1ca2acb9e', 'ab16650b-7a90-4398-853f-ce8b3ee9285e', 'pimientos (rojos)', 'Paprika (rot)', 2.0, '', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('16ee9867-3e23-40b0-b55a-2ed62a63bc65', 'ab16650b-7a90-4398-853f-ce8b3ee9285e', 'dientes de ajo', 'Knoblauchzehen', 3.0, '', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('78629a95-adbd-48bd-a5a8-e1054392c091', 'ab16650b-7a90-4398-853f-ce8b3ee9285e', 'zanahoria', 'Karotte', 1.0, '', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('91220ce8-047e-45b6-9c90-9403d220b977', 'ab16650b-7a90-4398-853f-ce8b3ee9285e', 'crème fraîche', 'Crème fraîche', 50.0, 'g', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('1e736dd3-f846-49f1-80b6-053a8e0e3fa3', 'ab16650b-7a90-4398-853f-ce8b3ee9285e', 'maíz', 'Mais', 100.0, 'g', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('1b4f572e-ba61-413d-b0c9-855024ca722d', 'ab16650b-7a90-4398-853f-ce8b3ee9285e', 'alubias rojas', 'Kidneybohnen', 150.0, 'g', 10);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('79a5ffc7-8d89-46fe-a782-0b7d671af73d', 'ab16650b-7a90-4398-853f-ce8b3ee9285e', 'aceite de oliva', 'Olivenöl', 2.0, 'cucharadas', 11);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('34d763ac-a0aa-486a-9fc8-9b7a0418de6e', 'ab16650b-7a90-4398-853f-ce8b3ee9285e', 'sal', 'Salz', 0.5, 'cucharadita', 12);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('27d65f4f-13d3-4fa9-b069-8b7f95722337', 'ab16650b-7a90-4398-853f-ce8b3ee9285e', 'pimienta', 'Pfeffer', 0.5, 'cucharadita', 13);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('bb940fab-f767-4c9a-a754-343178deeaa2', 'bbd41e1f-7bdf-4b9a-9cf1-d26194b6a424', 'pimientos', 'Paprika', 4.0, '', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('9ea0c900-7d98-4fcd-9cf9-bbf7c9e2047c', 'bbd41e1f-7bdf-4b9a-9cf1-d26194b6a424', 'carne picada (ternera)', 'Hackfleisch (Rind)', 400.0, 'g', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('bed614f4-a847-4259-a4ab-d0858ccdbc61', 'bbd41e1f-7bdf-4b9a-9cf1-d26194b6a424', 'cebolla', 'Zwiebel', 1.0, '', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('a0cd7ae0-92ba-4add-9cae-cb7e4d079843', 'bbd41e1f-7bdf-4b9a-9cf1-d26194b6a424', 'dientes de ajo', 'Knoblauchzehen', 2.0, '', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('e267b502-c176-4294-ab6c-db5d7d68bd2d', 'bbd41e1f-7bdf-4b9a-9cf1-d26194b6a424', 'feta', 'Feta', 200.0, 'g', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('060d884d-31c5-421a-885b-db7e9cf4579b', 'bbd41e1f-7bdf-4b9a-9cf1-d26194b6a424', 'concentrado de tomate', 'Tomatenmark', 2.0, 'cucharadas', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('b1cf5f37-a43e-48f1-bfcf-43e630365a35', 'bbd41e1f-7bdf-4b9a-9cf1-d26194b6a424', 'maíz', 'Mais', 200.0, 'g', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('f3d3ec33-5e48-495c-82c3-8328c4077f8f', 'bbd41e1f-7bdf-4b9a-9cf1-d26194b6a424', 'caldo de verduras', 'Gemüsebrühe', 500.0, 'ml', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('8dc92bab-5a27-4293-8cb7-5fb407441ca2', 'bbd41e1f-7bdf-4b9a-9cf1-d26194b6a424', 'aceite de oliva', 'Olivenöl', 2.0, 'cucharadas', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('6e9a3b0f-f59f-4bdc-8001-76bfdccc47a9', 'bbd41e1f-7bdf-4b9a-9cf1-d26194b6a424', 'sal', 'Salz', 0.5, 'cucharadita', 10);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('0147bb0a-025d-4c7a-b714-f1d367c8fc33', 'bbd41e1f-7bdf-4b9a-9cf1-d26194b6a424', 'pimienta', 'Pfeffer', 0.5, 'cucharadita', 11);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('7b817e87-d275-409e-8f5f-e4ae73c3befa', 'bbd41e1f-7bdf-4b9a-9cf1-d26194b6a424', 'pimentón dulce', 'Paprikapulver (edelsüß)', 0.5, 'cucharadita', 12);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('63155c26-7a46-400f-8dbd-77a6644adf94', 'd82b57a8-74ab-479e-ad62-04080f037ed7', 'escarola', 'Friseesalat', 0.5, '', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('eccfc1dd-02a8-41f4-a45d-c60e0f81c418', 'd82b57a8-74ab-479e-ad62-04080f037ed7', 'radicchio rojo', 'roter Radicchio', 0.5, '', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('6b3cd09b-2d01-468e-a75b-6d1433ff5979', 'd82b57a8-74ab-479e-ad62-04080f037ed7', 'tomates', 'Tomaten', 4.0, '', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('a3a868c1-b2f1-4a81-97a0-331618f275af', 'd82b57a8-74ab-479e-ad62-04080f037ed7', 'pimiento rojo', 'rote Paprika', 1.0, '', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('4eb0c08e-f1ee-4b58-8152-b3a84cae2b15', 'd82b57a8-74ab-479e-ad62-04080f037ed7', 'pimiento amarillo', 'elbe Paprika', 1.0, 'g', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('6e1da644-a37b-43aa-aae1-7844012f78fd', 'd82b57a8-74ab-479e-ad62-04080f037ed7', 'cebolla', 'Zwiebel', 1.0, '', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('bd2c8d59-4582-4123-a41c-4299654e05a5', 'd82b57a8-74ab-479e-ad62-04080f037ed7', 'aguacate', 'Avocado', 1.0, '', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('d394b2da-809e-46df-a670-648b8fadfc34', 'd82b57a8-74ab-479e-ad62-04080f037ed7', 'queso de cabra', 'Ziegenkäse', 250.0, 'g', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('010f5332-67d8-4acd-9208-4a37137967c0', 'd82b57a8-74ab-479e-ad62-04080f037ed7', 'piñones', 'Pinienkerne', 4.0, 'cucharadas', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('3d243cb2-2ffd-4faa-b614-05c861709e37', 'd82b57a8-74ab-479e-ad62-04080f037ed7', 'remolachas', 'Rote Bete', 2.0, '', 10);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('dea85b66-6fbc-4319-97f9-ddd8b50bce9d', 'd82b57a8-74ab-479e-ad62-04080f037ed7', 'aceite de oliva', 'Olivenöl', 2.0, 'cucharadas', 11);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('7a1168c0-29d8-4a3e-af44-15ba9d4b78e5', 'd82b57a8-74ab-479e-ad62-04080f037ed7', 'vinagre', 'Essig', 2.0, 'cucharadas', 12);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('2f76c899-b32a-4ad1-af57-548ab05a6f1b', 'd82b57a8-74ab-479e-ad62-04080f037ed7', 'aceite', 'Öl', 4.0, 'cucharadas', 13);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('a7f9518a-f1d8-4849-b1c6-111bc8562f9c', 'd82b57a8-74ab-479e-ad62-04080f037ed7', 'sal', 'Salz', 0.5, 'cucharadita', 14);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('119df161-e223-4cd9-969c-c3bc5d6e07bb', 'd82b57a8-74ab-479e-ad62-04080f037ed7', 'pimienta', 'Pfeffer', 0.5, 'cucharadita', 15);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('52473e3e-35d9-4ce6-8e7e-624560fb18d9', '984d2bfe-0278-4ac2-bfab-751a4fd4de2f', 'pimientos (rojos)', 'Paprika (rot)', 4.0, '', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('c8a8415a-6ee2-467d-afeb-70accb035e0f', '984d2bfe-0278-4ac2-bfab-751a4fd4de2f', 'carne picada (ternera)', 'Hackfleisch (Rind)', 400.0, 'g', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('94b907ba-3ba1-4b82-8633-ceacba6b4b5e', '984d2bfe-0278-4ac2-bfab-751a4fd4de2f', 'tomates', 'Tomaten', 3.0, '', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('4c8171c9-11f3-4b5a-b970-ed6977f67f49', '984d2bfe-0278-4ac2-bfab-751a4fd4de2f', 'tomate concentrado', 'Tomatenmark', 3.0, 'cucharadas', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('22646397-09ec-4310-a153-777b74326667', '984d2bfe-0278-4ac2-bfab-751a4fd4de2f', 'cebolla', 'Zwiebel', 1.0, '', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('7d2a246c-0188-4236-b691-0cdcfda1a7a4', '984d2bfe-0278-4ac2-bfab-751a4fd4de2f', 'dientes de ajo', 'Knoblauchzehen', 2.0, '', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('51df575d-2b6d-4156-a203-9f47de49e6ab', '984d2bfe-0278-4ac2-bfab-751a4fd4de2f', 'queso (rallado)', 'Käse (gerieben)', 100.0, 'g', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('5cd836de-6eba-4388-9a62-33132885f7de', '984d2bfe-0278-4ac2-bfab-751a4fd4de2f', 'caldo de verduras', 'Gemüsebrühe', 400.0, 'ml', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('9f3f851f-8756-4d4d-86e1-0ef78cf3a1c2', '984d2bfe-0278-4ac2-bfab-751a4fd4de2f', 'aceite de oliva', 'Olivenöl', 2.0, 'cucharadas', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('48ba0792-2982-4081-9667-0fd17f7fec83', '984d2bfe-0278-4ac2-bfab-751a4fd4de2f', 'sal', 'Salz', 0.5, 'cucharadita', 10);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('efe5c894-1116-4c64-9aff-57c2257c4ace', '984d2bfe-0278-4ac2-bfab-751a4fd4de2f', 'pimienta', 'Pfeffer', 0.5, 'cucharadita', 11);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('9f284cce-d2b1-4163-9beb-10ae54520d78', '984d2bfe-0278-4ac2-bfab-751a4fd4de2f', 'pimentón dulce', 'Paprikapulver (Edelsüß)', 0.5, 'cucharadita', 12);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('e1b34971-f218-4aa4-a553-1985004604e3', '7d1166f0-0e49-4cf2-bebc-5e2b4735dc9d', 'harina de almendras', 'Mandelmehl', 150.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('158baa0b-8830-4cac-95b1-4ca8546ef755', '7d1166f0-0e49-4cf2-bebc-5e2b4735dc9d', 'mozzarella', 'Mozzarella', 250.0, 'g', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('fe73e2d4-88d4-4326-9c9b-b3fed118a6de', '7d1166f0-0e49-4cf2-bebc-5e2b4735dc9d', 'quark (40% de grasa)', 'Quark (40% Fett)', 1.0, 'cda', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('f878cc5d-1a4a-4f4e-84fe-a1aa0d2009b5', '7d1166f0-0e49-4cf2-bebc-5e2b4735dc9d', 'huevos', 'Eier', 2.0, '', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('f26e73ee-c647-4cc8-b09d-95116174aab8', '7d1166f0-0e49-4cf2-bebc-5e2b4735dc9d', 'sal', 'Salz', 0.5, 'cdta', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('e3f162f0-5d4e-4e99-9156-a3979c6f4360', '7d1166f0-0e49-4cf2-bebc-5e2b4735dc9d', 'agua', 'Wasser', 2.0, 'cdas', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('58130e68-fc2d-4ba3-a2ba-90988fdc88ce', '7d1166f0-0e49-4cf2-bebc-5e2b4735dc9d', 'tomates', 'Tomaten', 4.0, '', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('abe63c80-9036-4c5e-b060-c83bf116e001', '7d1166f0-0e49-4cf2-bebc-5e2b4735dc9d', 'tomates troceados', 'stückige Tomaten', 200.0, 'g', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('9987ae9f-9504-4b5f-bace-49970ff639fe', '7d1166f0-0e49-4cf2-bebc-5e2b4735dc9d', 'tomate triturado', 'passierte Tomaten', 200.0, 'ml', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('06ecb67d-eee4-4c46-bae6-8c15b7eb8ef7', '7d1166f0-0e49-4cf2-bebc-5e2b4735dc9d', 'queso (rallado)', 'Käse (gerieben)', 100.0, 'g', 10);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('c33f100a-5bf9-407e-8d17-83100ad8c1bc', '7d1166f0-0e49-4cf2-bebc-5e2b4735dc9d', 'cebolla', 'Zwiebel', 1.0, '', 11);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('98af844e-204b-4a92-b36c-c7c274783831', '7d1166f0-0e49-4cf2-bebc-5e2b4735dc9d', 'dientes de ajo', 'Knoblauchzehen', 2.0, '', 12);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('0d5fa933-c2bc-40db-8bca-fbfa195255e6', '7d1166f0-0e49-4cf2-bebc-5e2b4735dc9d', 'hierbas secas', 'getrocknete Kräuter', 2.0, 'cdta', 13);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('d6264135-fd88-4f1b-95c2-775d17467b72', '7d1166f0-0e49-4cf2-bebc-5e2b4735dc9d', 'Hojas de albahaca', 'Basilikumblätter', 0, '', 14);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('20c26578-0dc7-4e13-bc0e-9eba9761f96a', '3aad3fd8-adf0-4645-b1f1-e268c1375178', 'harina de almendras', 'Mandelmehl', 100.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('debb3357-28bb-4dfb-a7a9-c284b3f19e4f', '3aad3fd8-adf0-4645-b1f1-e268c1375178', 'proteína en polvo (neutra)', 'Proteinpulver (neutral)', 100.0, 'g', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('ca5c7f60-995d-4442-990e-4cd3a7aba9c7', '3aad3fd8-adf0-4645-b1f1-e268c1375178', 'huevos', 'Eier', 4.0, '', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('5c704868-355d-4f7a-9a35-7f0c5243b606', '3aad3fd8-adf0-4645-b1f1-e268c1375178', 'agua', 'Wasser', 2.0, 'cucharadas', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('c1dfe408-e8f6-46f7-b6a9-93bc8b43be52', '3aad3fd8-adf0-4645-b1f1-e268c1375178', 'aceite', 'Öl', 1.0, 'cucharada', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('cf868c5c-3532-4bcf-807d-f7afcb2fb910', '3aad3fd8-adf0-4645-b1f1-e268c1375178', 'salmón ahumado', 'Räucherlachs', 250.0, 'g', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('c5da1ee9-06d3-42f8-bfd4-24ca1d62be96', '3aad3fd8-adf0-4645-b1f1-e268c1375178', 'queso crema', 'Frischkäse', 100.0, 'g', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('c6b14a94-cd94-46d3-8006-ed6467d8f34a', '3aad3fd8-adf0-4645-b1f1-e268c1375178', 'rábano picante', 'Meerrettich', 50.0, 'g', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('90308b62-5628-48af-9f6d-b955e76f5729', '3aad3fd8-adf0-4645-b1f1-e268c1375178', 'rúcula', 'Rucola', 60.0, 'g', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('277e06b4-ba25-4a7e-849c-6421cc0115b4', '3aad3fd8-adf0-4645-b1f1-e268c1375178', 'imón', 'Zitrone', 1.0, 'l', 10);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('c6562f0a-11de-4644-8b77-6ab5dae63ecd', '3aad3fd8-adf0-4645-b1f1-e268c1375178', 'sal', 'Salz', 0.5, 'cucharadita', 11);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('6a53d2e8-9ca8-4e6e-90c2-d00496370f0c', '3aad3fd8-adf0-4645-b1f1-e268c1375178', 'pimienta', 'Pfeffer', 0.5, 'cucharadita', 12);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('4937d9da-5a72-4885-b9c6-48687833321d', '4ddc37a1-218a-46f2-8fbb-414d628762b3', 'calabacines', 'Zucchinis', 2.0, '', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('9dd70091-49ee-4e8f-a21f-9c2f218b8a96', '4ddc37a1-218a-46f2-8fbb-414d628762b3', 'zanahorias', 'Möhren', 2.0, '', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('f6f6e870-4a19-4642-89c2-1f42b325b52c', '4ddc37a1-218a-46f2-8fbb-414d628762b3', 'pechuga de pollo', 'Hähnchenbrust', 400.0, 'g', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('38d5a178-cee6-4acb-810e-fcee99575622', '4ddc37a1-218a-46f2-8fbb-414d628762b3', 'champiñones', 'Champignons', 400.0, 'g', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('0a1a8f58-f94a-4764-960f-577d20320483', '4ddc37a1-218a-46f2-8fbb-414d628762b3', 'dientes de ajo', 'Knoblauchzehen', 2.0, '', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('8c6531e9-a45c-4055-8e4f-dad930f34860', '4ddc37a1-218a-46f2-8fbb-414d628762b3', 'aceite de oliva', 'Olivenöl', 2.0, 'cdas', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('61558146-5e93-4daf-a62a-5badd4b3da41', '4ddc37a1-218a-46f2-8fbb-414d628762b3', 'mantequilla', 'Butter', 2.0, 'cdas', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('28ca1359-4685-49eb-b1f0-4a3699820b03', '4ddc37a1-218a-46f2-8fbb-414d628762b3', 'nueces', 'Walnüsse', 40.0, 'g', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('1bd53ecb-6336-4f99-9d5f-978cbf59f040', '4ddc37a1-218a-46f2-8fbb-414d628762b3', 'semillas de sésamo', 'Sesamsamen', 4.0, 'cdtas', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('5f760931-57c2-4155-9df8-a179c44224a4', '4ddc37a1-218a-46f2-8fbb-414d628762b3', 'semillas de calabaza', 'Kürbiskerne', 4.0, 'cdtas', 10);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('877cb8af-b9bd-4948-9509-1445cb444f33', '4ddc37a1-218a-46f2-8fbb-414d628762b3', 'sal', 'Salz', 0.5, 'cdta', 11);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('df6d2138-d67a-46c5-ab5b-524a8c5cc02f', '4ddc37a1-218a-46f2-8fbb-414d628762b3', 'pimienta', 'Pfeffer', 0.5, 'cdta', 12);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('b711afa6-2f87-4f60-8a29-879c29a774b7', '4ddc37a1-218a-46f2-8fbb-414d628762b3', 'mantequilla de almendras', 'Mandelmus', 2.0, 'cdas', 13);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('0be67c44-7c99-4ba4-99af-4248fc99d34f', '4ddc37a1-218a-46f2-8fbb-414d628762b3', 'aceite de sésamo', 'Sesamöl', 1.0, 'cda', 14);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('b551323f-4acf-4a07-a248-d552647e60ed', '4ddc37a1-218a-46f2-8fbb-414d628762b3', 'zumo de lima', 'Limettensaft', 2.0, 'cdas', 15);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('40dc6eb9-fd0d-49c0-863a-94d243a32824', '4ddc37a1-218a-46f2-8fbb-414d628762b3', 'agua', 'Wasser', 4.0, 'cdas', 16);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('adb3ba77-8943-4c3b-b6e6-0f0cb3b499e0', '61a3f67d-7ecb-4a3c-b1d4-6984a1a189fc', 'calabacín', 'Zucchini', 800.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('7108be17-c88e-4534-afee-a3d23a700d8e', '61a3f67d-7ecb-4a3c-b1d4-6984a1a189fc', 'cebollas', 'Zwiebeln', 2.0, '', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('c0e2498a-3ddd-443d-8bd7-cdd55ffaacd4', '61a3f67d-7ecb-4a3c-b1d4-6984a1a189fc', 'dientes de ajo', 'Knoblauchzehen', 3.0, '', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('39f40363-4fb6-4110-9082-1ec6740c4d01', '61a3f67d-7ecb-4a3c-b1d4-6984a1a189fc', 'aceite de oliva', 'Olivenöl', 1.0, 'cda', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('363827d7-0e32-47d2-ac30-14326c0bb10e', '61a3f67d-7ecb-4a3c-b1d4-6984a1a189fc', 'carne picada (ternera)', 'Hackfleisch (Rind)', 500.0, 'g', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('95f09e52-1c20-4c03-8412-8479d74dc999', '61a3f67d-7ecb-4a3c-b1d4-6984a1a189fc', 'tomate triturado', 'passierte Tomaten', 400.0, 'g', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('2b71cb2f-3a6a-484d-b811-f9c8ce500849', '61a3f67d-7ecb-4a3c-b1d4-6984a1a189fc', 'concentrado de tomate', 'Tomatenmark', 5.0, 'cdas', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('e782fe5a-1d6a-4808-8e78-03075c769102', '61a3f67d-7ecb-4a3c-b1d4-6984a1a189fc', 'queso (rallado)', 'Käse (gerieben)', 40.0, 'g', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('cd324d86-3baa-4259-bffe-e65916613af8', '61a3f67d-7ecb-4a3c-b1d4-6984a1a189fc', 'sal', 'Salz', 0.5, 'cdta', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('d89e7748-6788-48d5-8579-81de85357019', '61a3f67d-7ecb-4a3c-b1d4-6984a1a189fc', 'pimienta', 'Pfeffer', 0.5, 'cdta', 10);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('2f7ee6c8-1879-406c-8f5c-6fa4d7157b8a', '51faf429-4a47-4c1e-9390-fd5a4c89644e', 'calabacines', 'Zucchini', 4.0, '', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('020557a0-fa48-42e5-99cb-4d6e8048eaf7', '51faf429-4a47-4c1e-9390-fd5a4c89644e', 'carne picada (ternera)', 'Hackfleisch (Rind)', 500.0, 'g', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('7db48bb8-d4a5-4dd9-9c11-68f655787de5', '51faf429-4a47-4c1e-9390-fd5a4c89644e', 'cebollas', 'Zwiebeln', 2.0, '', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('8e36fe75-441c-42de-a041-8962a5d7ab8a', '51faf429-4a47-4c1e-9390-fd5a4c89644e', 'dientes de ajo', 'Knoblauchzehen', 2.0, '', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('37593280-4ea6-4d4f-8c0a-d9d74376491f', '51faf429-4a47-4c1e-9390-fd5a4c89644e', 'tomates', 'Tomaten', 3.0, '', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('828cb943-38f0-4cb8-a2a4-db2259221731', '51faf429-4a47-4c1e-9390-fd5a4c89644e', 'queso (rallado)', 'Käse (gerieben)', 100.0, 'g', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('a926444e-1abf-41ea-9e57-69f646705725', '51faf429-4a47-4c1e-9390-fd5a4c89644e', 'champiñones', 'Champignons', 250.0, 'g', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('ecf014f3-04f0-49c9-a843-4afe4cdd2c2d', '51faf429-4a47-4c1e-9390-fd5a4c89644e', 'aceite de oliva', 'Olivenöl', 1.0, 'cucharada', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('cd778e07-9edc-44a2-af28-c982fc72facd', '51faf429-4a47-4c1e-9390-fd5a4c89644e', 'caldo de verduras', 'Gemüsebrühe', 150.0, 'ml', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('64fed835-9ba1-4adf-8681-7eb2261e1671', '51faf429-4a47-4c1e-9390-fd5a4c89644e', 'sal', 'Salz', 0.5, 'cucharadita', 10);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('a65bab69-2f39-47fc-a3ef-d38c1ff528d8', '51faf429-4a47-4c1e-9390-fd5a4c89644e', 'pimienta', 'Pfeffer', 0.5, 'cucharadita', 11);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('40834a65-6125-4986-9348-00dc47109cb3', '5a6a2244-9217-435e-be81-b6bf9ae0fc0b', 'pechuga de pollo (4x 150g)', 'Hähnchenbrust (4x 150g)', 600.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('849bf342-9b1a-4702-b3a0-86b017718b8a', '5a6a2244-9217-435e-be81-b6bf9ae0fc0b', 'sal', 'Salz', 1.0, 'cdta', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('4a080134-12c1-4556-90ca-6892951ddbd4', '5a6a2244-9217-435e-be81-b6bf9ae0fc0b', 'pimienta', 'Pfeffer', 0.5, 'cdta', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('d40fe75d-8da2-4580-a447-cb456077d27a', '5a6a2244-9217-435e-be81-b6bf9ae0fc0b', 'pimentón en polvo', 'Paprikapulver', 0.5, 'cdta', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('56bfc93d-e45d-4a5a-8e58-6388648d9caf', '5a6a2244-9217-435e-be81-b6bf9ae0fc0b', 'chile en polvo', 'Chilipulver', 0.5, 'cdta', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('407e9c53-eddf-4d8e-9579-99975b8eb8e9', '5a6a2244-9217-435e-be81-b6bf9ae0fc0b', 'aceite de oliva', 'Olivenöl', 2.0, 'cdas', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('70a0ee2c-7ae8-4b41-ab39-fe6c7a8212ba', '5a6a2244-9217-435e-be81-b6bf9ae0fc0b', 'dientes de ajo', 'Knoblauchzehen', 2.0, '', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('fff1a4b0-a7f9-4e72-b6b0-340485704de1', '5a6a2244-9217-435e-be81-b6bf9ae0fc0b', 'echuga', 'Kopfsalat', 1.0, 'l', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('8525e512-9d7d-4ede-b94c-6e6590a3fa39', '5a6a2244-9217-435e-be81-b6bf9ae0fc0b', 'pepino', 'Salatgurke', 1.0, '', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('207b0362-e5ea-476e-847b-f5b790194858', '5a6a2244-9217-435e-be81-b6bf9ae0fc0b', 'rúcula', 'Rucola', 200.0, 'g', 10);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('6b82af94-c857-4e74-b30f-1ac133dd2993', '5a6a2244-9217-435e-be81-b6bf9ae0fc0b', 'piñones', 'Pinienkerne', 2.0, 'cdas', 11);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('f2646a14-6b53-4022-aa21-23eaa9a8470c', '5a6a2244-9217-435e-be81-b6bf9ae0fc0b', 'cebollas rojas', 'rote Zwiebeln', 2.0, '', 12);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('4308f504-5316-40d9-93ab-0791ce016564', '5a6a2244-9217-435e-be81-b6bf9ae0fc0b', 'tomates cherry', 'Cocktailtomaten', 250.0, 'g', 13);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('0ed52f5b-371b-41cd-8f7a-7bbc2002005c', '5a6a2244-9217-435e-be81-b6bf9ae0fc0b', 'aceite de oliva', 'Olivenöl', 3.0, 'cdas', 14);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('18ce6157-14af-430a-8c0a-c33d08e6149f', '5a6a2244-9217-435e-be81-b6bf9ae0fc0b', 'vinagre de vino blanco', 'Weißweinessig', 2.0, 'cdas', 15);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('738091d1-ca0f-42c6-b59b-a5654df0e610', '5a6a2244-9217-435e-be81-b6bf9ae0fc0b', 'agua', 'Wasser', 2.0, 'cdas', 16);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('57a34bd6-0e7f-4d20-9276-d5a91d30b721', '5a6a2244-9217-435e-be81-b6bf9ae0fc0b', 'sal', 'Salz', 0.5, 'cdta', 17);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('4cda9259-1bec-417c-ac41-d6604f0ffa3a', '5a6a2244-9217-435e-be81-b6bf9ae0fc0b', 'pimienta', 'Pfeffer', 0.5, 'cdta', 18);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('b6f37e96-46e1-4d4f-9372-8b3babad2f3c', 'bc45cf13-fd00-40bb-8962-7b6078dc3d68', 'calabaza (Hokkaido)', 'Kürbis (Hokkaido)', 500.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('16b253e5-4dd0-4f74-b823-e8618f414c88', 'bc45cf13-fd00-40bb-8962-7b6078dc3d68', 'carne picada (ternera)', 'Hackfleisch (Rind)', 500.0, 'g', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('c8aed37a-1496-4c5f-9227-a5f35174d145', 'bc45cf13-fd00-40bb-8962-7b6078dc3d68', 'tomate triturado', 'passierte Tomaten', 400.0, 'ml', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('5d52cead-f535-45a0-b29f-a757922b8b33', 'bc45cf13-fd00-40bb-8962-7b6078dc3d68', 'tomate en trozos', 'stückige Tomaten', 500.0, 'g', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('219f2469-f0cf-4bc8-904b-ff3745d5b58e', 'bc45cf13-fd00-40bb-8962-7b6078dc3d68', 'pimiento rojo', 'rote Paprika', 1.0, '', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('12d5024e-5c64-413d-b880-e35b4fa8ee7c', 'bc45cf13-fd00-40bb-8962-7b6078dc3d68', 'cebolla', 'Zwiebel', 1.0, '', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('4e4b3940-88b9-43c8-a0e4-7758ae776674', 'bc45cf13-fd00-40bb-8962-7b6078dc3d68', 'dientes de ajo', 'Knoblauchzehen', 2.0, '', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('f9ffb7f4-664f-4ecb-bff6-abb316933947', 'bc45cf13-fd00-40bb-8962-7b6078dc3d68', 'mantequilla', 'Butter', 2.0, 'cucharadas', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('61cd32cf-7b00-4f37-acb3-f8fc224caeea', 'bc45cf13-fd00-40bb-8962-7b6078dc3d68', 'orégano', 'Oregano', 1.0, 'cucharadita', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('06d1aeba-818b-4fab-bdd3-b982f61d4404', 'bc45cf13-fd00-40bb-8962-7b6078dc3d68', 'pimentón', 'Paprikapulver', 0.5, 'cucharadita', 10);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('767ca7fb-221a-4fd0-a7f9-834e1c776d81', 'bc45cf13-fd00-40bb-8962-7b6078dc3d68', 'sal', 'Salz', 0.5, 'cucharadita', 11);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('790e28ab-e326-47d8-8264-d9bc555e5f8c', 'bc45cf13-fd00-40bb-8962-7b6078dc3d68', 'pimienta', 'Pfeffer', 0.5, 'cucharadita', 12);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('2d9b7dcf-a3fd-4624-8bcc-f0dd4dd5cdcb', '7aa1bc81-1ae9-4f29-bdae-7f27ebc5e0b5', 'salmón (4 x 150g)', 'Lachs (4 x 150g)', 600.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('f80b08af-088c-45e8-a8db-2ff59d178480', '7aa1bc81-1ae9-4f29-bdae-7f27ebc5e0b5', 'espinacas frescas', 'Blattspinat', 800.0, 'g', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('5c0674f2-9f1d-4cac-8bf6-ea4eb67525a5', '7aa1bc81-1ae9-4f29-bdae-7f27ebc5e0b5', 'dientes de ajo', 'Knoblauchzehen', 4.0, '', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('01caffe4-6ccb-40a6-bed8-417e84fe9397', '7aa1bc81-1ae9-4f29-bdae-7f27ebc5e0b5', 'imón', 'Zitrone', 1.0, 'l', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('858a2333-25b0-47af-a270-d04a7a5d4115', '7aa1bc81-1ae9-4f29-bdae-7f27ebc5e0b5', 'sal', 'Salz', 0.5, 'cucharadita', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('f1fbee4b-edaf-4636-b5ec-ab56b1a0fbbf', '7aa1bc81-1ae9-4f29-bdae-7f27ebc5e0b5', 'pimienta', 'Pfeffer', 0.5, 'cucharadita', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('de6f1a8e-bd43-4c0c-aacd-beb9175dffbf', '7aa1bc81-1ae9-4f29-bdae-7f27ebc5e0b5', 'aceite de oliva', 'Olivenöl', 3.0, 'cucharadas', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('032010d1-503f-4844-9010-0259c724f8e1', '7aa1bc81-1ae9-4f29-bdae-7f27ebc5e0b5', 'crème fraîche', 'Crème fraîche', 150.0, 'g', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('c576a0ba-c0ec-43d8-8ae2-3d70a0838615', '7aa1bc81-1ae9-4f29-bdae-7f27ebc5e0b5', 'perejil', 'Petersilie', 3.0, 'cucharadas', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('f4f7e9a7-3d55-4b42-91d3-fabf68896a50', '7aa1bc81-1ae9-4f29-bdae-7f27ebc5e0b5', 'imón', 'Zitrone', 0.5, 'l', 10);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('1faecbe3-e769-4100-a0bc-0d5befc8062b', '7aa1bc81-1ae9-4f29-bdae-7f27ebc5e0b5', 'aceite de oliva', 'Olivenöl', 1.0, 'cucharadita', 11);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('b23375b3-0858-4365-b53f-1b669ba11e9c', '7aa1bc81-1ae9-4f29-bdae-7f27ebc5e0b5', 'chorrito de vinagre', 'Spritzer Essig', 1.0, '', 12);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('ca7bdd9d-7b1c-4056-9810-5cf18b4cdafc', 'da3bffdb-bc4f-4f17-a3d5-8bf7fea4cf22', 'filetes de salmón (180g cada uno)', 'achsfilets (je 180g)', 4.0, 'L', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('83af41c1-9356-43c6-a5d7-d6501f7372cd', 'da3bffdb-bc4f-4f17-a3d5-8bf7fea4cf22', 'mantequilla', 'Butter', 2.0, 'cucharadas', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('8e39dc21-7176-4e9c-b72e-dae9ccab4739', 'da3bffdb-bc4f-4f17-a3d5-8bf7fea4cf22', 'pimienta', 'Pfeffer', 0.5, 'cucharadita', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('2dc374b9-df1f-4c7e-a31a-4cd22e40ec53', 'da3bffdb-bc4f-4f17-a3d5-8bf7fea4cf22', 'sal', 'Salz', 0.5, 'cucharadita', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('46ec472a-65a5-4808-9330-9ba7fb233554', 'da3bffdb-bc4f-4f17-a3d5-8bf7fea4cf22', 'imón', 'Zitrone', 1.0, 'l', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('bb2855bd-b737-437d-9ef4-ea66ec2523ab', 'da3bffdb-bc4f-4f17-a3d5-8bf7fea4cf22', 'rúcula', 'Rucola', 240.0, 'g', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('10418444-e4a7-4b40-b801-4fd1245daf75', 'da3bffdb-bc4f-4f17-a3d5-8bf7fea4cf22', 'cebollas rojas', 'rote Zwiebeln', 2.0, '', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('8e6c40b7-cd9d-4ff7-8a09-248d816b5aaf', 'da3bffdb-bc4f-4f17-a3d5-8bf7fea4cf22', 'tomates cherry', 'Cocktailtomaten', 300.0, 'g', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('3fd3fa60-5988-45cf-80f9-5acca751c7d5', 'da3bffdb-bc4f-4f17-a3d5-8bf7fea4cf22', 'imón', 'Zitrone', 1.0, 'l', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('5a48b133-8388-4def-a771-81457842788a', 'da3bffdb-bc4f-4f17-a3d5-8bf7fea4cf22', 'echuga', 'Kopfsalat', 0.5, 'l', 10);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('54b8ed89-a259-41ec-ae51-65edb42050e6', 'da3bffdb-bc4f-4f17-a3d5-8bf7fea4cf22', 'aceite de oliva', 'Olivenöl', 4.0, 'cucharadas', 11);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('07d74eba-c02e-4a6c-8887-d30cb46e6336', 'da3bffdb-bc4f-4f17-a3d5-8bf7fea4cf22', 'dientes de ajo', 'Knoblauchzehen', 2.0, '', 12);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('deb5fdbe-f728-49d9-9ee5-1a7da1633548', 'da3bffdb-bc4f-4f17-a3d5-8bf7fea4cf22', 'sal', 'Salz', 0.5, 'cucharadita', 13);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('60533e3f-3112-431d-8056-3e4bacbd9d49', 'da3bffdb-bc4f-4f17-a3d5-8bf7fea4cf22', 'pimienta', 'Pfeffer', 0.5, 'cucharadita', 14);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('b569c621-2294-4506-9453-a3d1324eb6f0', 'e3f02c01-a693-4ee7-af43-bea465cf41e8', 'calabacín Calorías 469', 'Zucchini Kalorien 469', 600.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('72772295-d655-4589-a3a6-fd72773d62e6', 'e3f02c01-a693-4ee7-af43-bea465cf41e8', 'cebolla', 'Zwiebel', 1.0, '', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('0d7f6111-8502-4400-a1c3-d80958155ca7', 'e3f02c01-a693-4ee7-af43-bea465cf41e8', 'dientes de ajo', 'Knoblauchzehen', 2.0, '', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('2f67e791-03f6-4e04-a5fd-ef40bf0ef38c', 'e3f02c01-a693-4ee7-af43-bea465cf41e8', 'aceite de oliva', 'Olivenöl', 1.0, 'cucharada', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('44982369-5b2a-41c3-bf21-9b644d0dfece', 'e3f02c01-a693-4ee7-af43-bea465cf41e8', 'queso (rallado)', 'Käse (gerieben)', 100.0, 'g', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('d2474988-03af-4bac-acec-d2569a97b5af', 'e3f02c01-a693-4ee7-af43-bea465cf41e8', 'parmesano', 'Parmesan', 60.0, 'g', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('72cad283-ac9f-4dcb-96d2-1d183dacb16f', 'e3f02c01-a693-4ee7-af43-bea465cf41e8', 'carne picada de ternera', 'Rinderhackfleisch', 400.0, 'g', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('99be3e86-1d99-4faa-84a4-0f9f57f9d35f', 'e3f02c01-a693-4ee7-af43-bea465cf41e8', 'tomates troceados (1 lata)', 'stückige Tomaten (1 Dose)', 400.0, 'g', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('92aad6c3-aca5-4bd0-9daa-8bab34ab3384', 'e3f02c01-a693-4ee7-af43-bea465cf41e8', 'mantequilla', 'Butter', 1.0, 'cucharadita', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('5c60f714-f1b1-4e30-a6a6-c1229221b027', '4b8a5eb8-e181-45e9-b7a2-8704f28f128f', 'brócoli', 'Brokkoli', 600.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('23cd35d6-1faf-4ae5-a84e-5c665d5f601d', '4b8a5eb8-e181-45e9-b7a2-8704f28f128f', 'huevos', 'Eier', 4.0, '', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('60342193-f623-40a3-8062-e5506c21c476', '4b8a5eb8-e181-45e9-b7a2-8704f28f128f', 'queso (rallado)', 'Käse (gerieben)', 60.0, 'g', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('cce3eb33-9432-4785-acc2-7cbda67b53c4', '4b8a5eb8-e181-45e9-b7a2-8704f28f128f', 'harina de almendras', 'Mandelmehl', 50.0, 'g', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('8fa1cf54-acb9-451f-82f5-dcc05c97219f', '4b8a5eb8-e181-45e9-b7a2-8704f28f128f', 'manojo de cebollino', 'Bund Schnittlauch', 1.0, '', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('286820f3-ce3f-430b-b3b1-74107edae1fe', '4b8a5eb8-e181-45e9-b7a2-8704f28f128f', 'quark desnatado', 'Magerquark', 300.0, 'g', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('6e778a99-a345-4b8e-a929-8315fab33f6c', '4b8a5eb8-e181-45e9-b7a2-8704f28f128f', 'crema agria', 'Schmand', 50.0, 'g', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('1411e412-5cef-4640-89a7-553989f48d70', '4b8a5eb8-e181-45e9-b7a2-8704f28f128f', 'cebolla', 'Zwiebel', 1.0, '', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('8caf5543-c6d4-484e-b727-8f6858b6eb7c', '4b8a5eb8-e181-45e9-b7a2-8704f28f128f', 'dientes de ajo', 'Knoblauchzehen', 2.0, '', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('6ef845c4-7e08-4307-8acc-edacb47efef2', '4b8a5eb8-e181-45e9-b7a2-8704f28f128f', 'agua con gas', 'Wasser (mit Kohlensäure)', 4.0, 'cucharadas', 10);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('fc0873eb-b38d-4af3-b650-c34df0027e7f', '4b8a5eb8-e181-45e9-b7a2-8704f28f128f', 'aceite de oliva', 'Olivenöl', 5.0, 'cucharadas', 11);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('aac1bbf5-1ca9-4e77-9097-5533643297a7', '4b8a5eb8-e181-45e9-b7a2-8704f28f128f', 'sal', 'Salz', 0.5, 'cucharadita', 12);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('474c8ad3-cc52-42e3-a901-a403acc5654f', '4b8a5eb8-e181-45e9-b7a2-8704f28f128f', 'pimienta', 'Pfeffer', 0.5, 'cucharadita', 13);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('cda59dc5-371e-4cda-9775-0b24660221ed', 'a6247d60-aa54-456d-bbed-62019aa8dae7', 'pechuga de pollo', 'Hähnchenbrust', 600.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('ba50a50c-7d70-43f9-b91d-149b65a32368', 'a6247d60-aa54-456d-bbed-62019aa8dae7', 'parmesano (rallado)', 'Parmesan (gerieben)', 100.0, 'g', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('51f208f2-4071-4a4d-a78b-32786935b1e4', 'a6247d60-aa54-456d-bbed-62019aa8dae7', 'huevos', 'Eier', 4.0, '', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('6ce5bf79-026e-46bf-a3f4-fa44d6e9ac47', 'a6247d60-aa54-456d-bbed-62019aa8dae7', 'almendras (molidas)', 'Mandeln (gemahlen)', 100.0, 'g', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('b03d0d09-1432-4bab-8219-89b522dcabdc', 'a6247d60-aa54-456d-bbed-62019aa8dae7', 'sal', 'Salz', 1.0, 'cucharadita', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('d3a74f1f-e71a-46f3-9a30-8cd5b57eedbe', 'a6247d60-aa54-456d-bbed-62019aa8dae7', 'pimienta', 'Pfeffer', 0.5, 'cucharadita', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('e32037c4-ac96-4343-b0be-5ceaafae5b7b', 'a6247d60-aa54-456d-bbed-62019aa8dae7', 'cúrcuma', 'Kurkuma', 0.5, 'cucharadita', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('1094549e-beaf-40ce-aaf0-e6750cb54e1e', 'a6247d60-aa54-456d-bbed-62019aa8dae7', 'imón', 'Zitrone', 1.0, 'l', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('fed040c7-1985-4ae6-b283-bd5967c89c79', '810d9e0e-a632-496a-833b-7f388debd8db', 'pechuga de pollo', 'Hähnchenbrust', 800.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('ee324e73-70d4-4aef-b636-973f03adf282', '810d9e0e-a632-496a-833b-7f388debd8db', 'aceite de oliva', 'Olivenöl', 1.0, 'cda', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('6af76fe3-ef0a-455c-9340-da375fe4a42d', '810d9e0e-a632-496a-833b-7f388debd8db', 'sal', 'Salz', 0.5, 'cdta', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('99159300-840a-459b-9aff-d2036e87352a', '810d9e0e-a632-496a-833b-7f388debd8db', 'pimienta', 'Pfeffer', 0.5, 'cdta', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('1c695dd0-7b8c-47db-840a-cff541859391', '810d9e0e-a632-496a-833b-7f388debd8db', 'espinacas', 'Blattspinat', 200.0, 'g', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('cffe40ef-dc41-4261-84fc-fe4b8eb1f118', '810d9e0e-a632-496a-833b-7f388debd8db', 'judías verdes', 'grüne Bohnen', 100.0, 'g', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('d2a59814-7652-4387-b036-85295a996d75', '810d9e0e-a632-496a-833b-7f388debd8db', 'tomates de rama', 'Strauchtomaten', 4.0, '', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('36be24fd-c7bd-46e7-b99f-91a8f6090d40', '810d9e0e-a632-496a-833b-7f388debd8db', 'aguacate', 'Avocado', 1.0, '', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('82afcb73-6c73-4ad0-a4a0-07a6e47f5559', '810d9e0e-a632-496a-833b-7f388debd8db', 'rúcula', 'Rucola', 150.0, 'g', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('e39573ae-771e-4f6a-84cf-03fd65cf679a', '810d9e0e-a632-496a-833b-7f388debd8db', 'cebollas rojas', 'rote Zwiebeln', 2.0, '', 10);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('5cc94ee8-8e1e-4f9c-9579-a8c919072f70', '810d9e0e-a632-496a-833b-7f388debd8db', 'dientes de ajo', 'Knoblauchzehen', 2.0, '', 11);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('0f058817-bbba-451b-96df-5f6e33bb2f8d', '810d9e0e-a632-496a-833b-7f388debd8db', 'aceite de oliva', 'Olivenöl', 4.0, 'cdas', 12);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('49ffd21f-32fe-4fa7-bedf-efe43dad487c', '810d9e0e-a632-496a-833b-7f388debd8db', 'vinagre', 'Essig', 0.5, 'cda', 13);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('e4f6b48c-3246-461a-861c-de4a6428de6e', '810d9e0e-a632-496a-833b-7f388debd8db', 'sal', 'Salz', 0.5, 'cdta', 14);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('9c2c0372-c889-4594-8ff0-2b16fad5c190', '810d9e0e-a632-496a-833b-7f388debd8db', 'pimienta', 'Pfeffer', 0.5, 'cdta', 15);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('e57a6652-9e73-47ea-a1e9-8d251bff6cb7', '810d9e0e-a632-496a-833b-7f388debd8db', 'imón', 'Zitrone', 1.0, 'l', 16);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('6fb9b0a9-ca55-4f64-a2ac-4ad427678942', '656ce37d-e762-41f9-b715-3463ce166bf2', 'requesón (20% de grasa)', 'Quark (20% Fett)', 250.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('b441c9e4-832f-4a7d-b500-fe44f5d952a3', '656ce37d-e762-41f9-b715-3463ce166bf2', 'huevos', 'Eier', 5.0, '', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('2205283d-877e-485a-8537-94d8db880240', '656ce37d-e762-41f9-b715-3463ce166bf2', 'queso (rallado)', 'Käse (gerieben)', 250.0, 'g', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('efc6876b-d71d-4ded-b9db-203404082ebb', '656ce37d-e762-41f9-b715-3463ce166bf2', 'pechuga de pollo', 'Hähnchenbrust', 300.0, 'g', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('5c6cdcd1-4ec6-45d9-a83d-b935ca11d447', '656ce37d-e762-41f9-b715-3463ce166bf2', 'queso crema (bajo en grasa)', 'Frischkäse (fettarm)', 150.0, 'g', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('180b5b0b-1b60-414b-aa3f-bd198b0359fa', '656ce37d-e762-41f9-b715-3463ce166bf2', 'tomates', 'Tomaten', 3.0, '', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('e35037f9-d0a0-4de8-aa20-dd2f297ac5f8', '656ce37d-e762-41f9-b715-3463ce166bf2', 'puñados de rúcula', 'Handvoll Rucola', 2.0, '', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('07e92b52-69a9-46ed-aaec-970acba0d817', '656ce37d-e762-41f9-b715-3463ce166bf2', 'echuga', 'Kopfsalat', 0.5, 'l', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('e3616684-bce9-4a28-9888-ec34019beed4', '656ce37d-e762-41f9-b715-3463ce166bf2', 'imón', 'Zitrone', 1.0, 'l', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('3041b96e-7da8-4a03-bd36-2ab1d4c2a0f8', '656ce37d-e762-41f9-b715-3463ce166bf2', 'sal', 'Salz', 0.5, 'cucharadita', 10);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('ca7b1461-a9f6-4fe6-bdb1-9887a819706b', '656ce37d-e762-41f9-b715-3463ce166bf2', 'pimienta', 'Pfeffer', 0.5, 'cucharadita', 11);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('85faa3d3-0ea6-4d47-ae09-872b8ba59399', '656ce37d-e762-41f9-b715-3463ce166bf2', 'aceite de oliva', 'Olivenöl', 1.0, 'cucharada', 12);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('098d0643-36a8-46cb-9f9f-9d154d818212', '88b7567b-a5d3-4b24-9fc6-483fb08dd09f', 'coliflor', 'Blumenkohl', 800.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('6c5d0129-92f0-4d4a-b3a4-0b675339f74f', '88b7567b-a5d3-4b24-9fc6-483fb08dd09f', 'queso (rallado)', 'Käse (gerieben)', 250.0, 'g', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('6cd297f5-6ad6-413a-b78d-1fde60bbc0ef', '88b7567b-a5d3-4b24-9fc6-483fb08dd09f', 'huevos', 'Eier', 2.0, '', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('fdac30d3-9cb5-4b0c-ba06-bc0302ec9e62', '88b7567b-a5d3-4b24-9fc6-483fb08dd09f', 'sal', 'Salz', 0.5, 'cdta', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('6ee73cfc-a32d-4e63-abe3-ff2f644fd98d', '88b7567b-a5d3-4b24-9fc6-483fb08dd09f', 'pechuga de pollo', 'Hähnchenbrust', 400.0, 'g', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('2bf3bdca-4d8f-4333-8362-29c13bd98953', '88b7567b-a5d3-4b24-9fc6-483fb08dd09f', 'tomates troceados (1 lata)', 'stückige Tomaten (1 Dose)', 400.0, 'g', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('c171d2c3-adce-496d-9064-91db683364a9', '88b7567b-a5d3-4b24-9fc6-483fb08dd09f', 'concentrado de tomate', 'Tomatenmark', 2.0, 'cdas', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('4d7c09e4-34eb-4f6d-a2f7-1d2d47328ff8', '88b7567b-a5d3-4b24-9fc6-483fb08dd09f', 'aceite de oliva', 'Olivenöl', 2.0, 'cdtas', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('7030357a-7094-48df-876f-9db9517cba42', '88b7567b-a5d3-4b24-9fc6-483fb08dd09f', 'cebolla', 'Zwiebel', 1.0, '', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('bbb92eae-fd89-414a-9389-240c4a9dcf6e', '88b7567b-a5d3-4b24-9fc6-483fb08dd09f', 'dientes de ajo', 'Knoblauchzehen', 2.0, '', 10);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('27137675-144c-46a3-ba0c-4769843f7da0', '88b7567b-a5d3-4b24-9fc6-483fb08dd09f', 'tomates cherry', 'Cocktailtomaten', 200.0, 'g', 11);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('f93caca2-f1d2-4375-a612-6232cbe8643f', '88b7567b-a5d3-4b24-9fc6-483fb08dd09f', 'rúcula', 'Rucola', 200.0, 'g', 12);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('1c9f409e-f152-459f-a709-1264788a3e66', '88b7567b-a5d3-4b24-9fc6-483fb08dd09f', 'queso (rallado)', 'Käse (gerieben)', 100.0, 'g', 13);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('7894324a-6cc6-4cf3-bb29-fa12450631a0', '864e4902-9496-4caf-a884-9bb5654cb5e8', 'requesón desnatado', 'Magerquark', 200.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('82432dea-7819-44a5-b5a4-98aa43963249', '864e4902-9496-4caf-a884-9bb5654cb5e8', 'huevos', 'Eier', 4.0, '', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('76950597-76c9-4fd2-9c97-06c1cb7fade7', '864e4902-9496-4caf-a884-9bb5654cb5e8', 'harina de almendras', 'Mandelmehl', 50.0, 'g', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('6c1978e8-87d8-472e-861e-05acb818f436', '864e4902-9496-4caf-a884-9bb5654cb5e8', 'queso (rallado)', 'Käse (gerieben)', 200.0, 'g', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('011aaaff-477c-48ac-aaca-502150eccb06', '864e4902-9496-4caf-a884-9bb5654cb5e8', 'cáscaras de psyllium', 'Flohsamenschalen', 1.0, 'cucharada', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('6ab5495c-734b-47d0-989c-66a0f8ddca83', '864e4902-9496-4caf-a884-9bb5654cb5e8', 'levadura en polvo', 'Backpulver', 0.5, 'cucharadita', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('022192fe-9935-45e4-b661-42d2398c71a2', '864e4902-9496-4caf-a884-9bb5654cb5e8', 'sal', 'Salz', 0.5, 'cucharadita', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('1e85791b-ade7-4623-8d58-acc72f97f5b0', '864e4902-9496-4caf-a884-9bb5654cb5e8', 'onchas de queso', 'Käse', 6.0, 'l', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('994d183c-d2ce-445a-bb84-6dd044a2df58', '864e4902-9496-4caf-a884-9bb5654cb5e8', 'salami de ave (en lonchas)', 'Geflügelsalami (in Scheiben)', 60.0, 'g', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('5d009b12-9dd5-46aa-9e95-c6415272226c', '864e4902-9496-4caf-a884-9bb5654cb5e8', 'cebollas', 'Zwiebeln', 2.0, '', 10);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('2ddea225-71ea-4dcb-a461-6f68b59c35ec', '864e4902-9496-4caf-a884-9bb5654cb5e8', 'dientes de ajo', 'Knoblauchzehen', 2.0, '', 11);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('dd5a4d97-2187-4fef-befd-fb7662eabfe8', '864e4902-9496-4caf-a884-9bb5654cb5e8', 'tomates troceados (1 lata)', 'stückige Tomaten (1 Dose)', 400.0, 'g', 12);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('d60700bf-b6da-4afd-80d7-ea3c290e6983', '864e4902-9496-4caf-a884-9bb5654cb5e8', 'sal', 'Salz', 0.5, 'cucharadita', 13);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('3b430b23-516c-45e0-a754-af896c21e78c', '864e4902-9496-4caf-a884-9bb5654cb5e8', 'pimienta', 'Pfeffer', 0.5, 'cucharadita', 14);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('e003e8c7-56b3-42ec-87be-4f828af3f813', '864e4902-9496-4caf-a884-9bb5654cb5e8', 'queso (rallado)', 'Käse (gerieben)', 50.0, 'g', 15);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('1c261cb3-f5cd-43a0-9f14-a82c365ed0a4', '111ff8b9-5938-4d3d-b63a-b8c0534f225d', 'queso quark desnatado', 'Magerquark', 250.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('6f5f2261-d2e8-4e77-9775-a2709ab69f32', '111ff8b9-5938-4d3d-b63a-b8c0534f225d', 'queso (rallado)', 'Käse (gerieben)', 130.0, 'g', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('cd156716-f61b-4929-83e5-669c0cc7935e', '111ff8b9-5938-4d3d-b63a-b8c0534f225d', 'huevos', 'Eier', 3.0, '', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('b0b3f7c8-5fff-43eb-a087-0c76b318e646', '111ff8b9-5938-4d3d-b63a-b8c0534f225d', 'sal', 'Salz', 0.5, 'cdta', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('d5668650-5747-4df4-aaf0-4e01e28d31c2', '111ff8b9-5938-4d3d-b63a-b8c0534f225d', 'carne picada (ternera)', 'Hackfleisch (Rind)', 400.0, 'g', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('92838b3e-92aa-45f7-9413-b77a9603d161', '111ff8b9-5938-4d3d-b63a-b8c0534f225d', 'cebolla', 'Zwiebel', 1.0, '', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('5a97aa02-d86f-43ed-a936-b78d03e85afe', '111ff8b9-5938-4d3d-b63a-b8c0534f225d', 'dientes de ajo', 'Knoblauchzehen', 2.0, '', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('94a48210-a8a6-4737-8233-96259a1da58a', '111ff8b9-5938-4d3d-b63a-b8c0534f225d', 'tomate (triturado)', 'Tomaten (passiert)', 500.0, 'g', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('d4abbfb3-8a7b-42e7-9e9d-dc3a8dd59442', '111ff8b9-5938-4d3d-b63a-b8c0534f225d', 'tomate (en trozos)', 'Tomaten (stückig)', 400.0, 'g', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('49306124-ce08-47aa-a147-176eb1764b5c', '111ff8b9-5938-4d3d-b63a-b8c0534f225d', 'nata', 'Sahne', 100.0, 'ml', 10);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('0970342f-b231-4d1d-ab3b-e0d71c695170', '111ff8b9-5938-4d3d-b63a-b8c0534f225d', 'queso (rallado)', 'Käse (gerieben)', 60.0, 'g', 11);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('1dcb3d7d-d9ec-40f8-b7b4-33d349d4a7d2', '111ff8b9-5938-4d3d-b63a-b8c0534f225d', 'aceite de oliva', 'Olivenöl', 1.0, 'cda', 12);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('67f2fa89-4725-43ab-927b-765d1c209664', '111ff8b9-5938-4d3d-b63a-b8c0534f225d', 'concentrado de tomate', 'Tomatenmark', 2.0, 'cdta', 13);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('9e60a941-281d-4395-b5db-b6d682c64fe4', '111ff8b9-5938-4d3d-b63a-b8c0534f225d', 'puñado de rúcula', 'Handvoll Rucola', 1.0, '', 14);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('5f8c1320-d984-423d-aa4e-393f2b09e9f5', '111ff8b9-5938-4d3d-b63a-b8c0534f225d', 'sal', 'Salz', 0.5, 'cdta', 15);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('9eee02bd-551b-4043-8f0f-1ba1499c3549', '111ff8b9-5938-4d3d-b63a-b8c0534f225d', 'pimienta', 'Pfeffer', 0.5, 'cdta', 16);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('673fd141-8bb9-48dc-a984-06eb5c22111b', '413c6d79-6e35-4d9f-8f08-4b3770979e1d', 'frambuesas', 'Himbeeren', 100.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('d3f279d9-2be7-493c-abe8-da9d9b725fef', '413c6d79-6e35-4d9f-8f08-4b3770979e1d', 'semillas de chía', 'Chia Samen', 1.0, 'cda', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('e5ac3fca-a933-4861-bfff-0a25630f3acf', '413c6d79-6e35-4d9f-8f08-4b3770979e1d', 'leche (1,5% grasa)', 'Milch (1,5% Fett)', 100.0, 'ml', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('5278e406-b25e-4180-aabc-c483ed9715e6', '413c6d79-6e35-4d9f-8f08-4b3770979e1d', 'zumo de limón', 'Zitronensaft', 1.0, 'cdta', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('6c41fa51-c23e-4a98-a52d-bade38e7e7af', '413c6d79-6e35-4d9f-8f08-4b3770979e1d', 'edulcorante (líquido)', 'Süßstoff (flüssig)', 1.0, 'cda', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('2378f41d-72c0-4284-89dc-e92180630161', '35fab555-8e41-4615-95fd-0a5c7a139aa0', 'calabacín', 'Zucchini', 200.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('e5d1ba26-4d5d-4c9c-b029-81ff2f9a5b83', '35fab555-8e41-4615-95fd-0a5c7a139aa0', 'vinagre de manzana', 'Apfelessig', 1.0, 'cda', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('246f9718-628d-4964-9160-41de4d6d4d57', '35fab555-8e41-4615-95fd-0a5c7a139aa0', 'aceite de oliva', 'Olivenöl', 2.0, 'cdta', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('c8b9355e-e353-40c2-8a04-14c8dd34c0b7', '35fab555-8e41-4615-95fd-0a5c7a139aa0', 'parmesano (rallado)', 'Parmesan (gerieben)', 1.0, 'cda', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('1096b61b-e611-4dad-b9d4-9f45d0830695', '35fab555-8e41-4615-95fd-0a5c7a139aa0', 'sal', 'Salz', 1.0, 'cdta', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('ecc28be5-fd20-4559-aa6f-7eb520993558', '93b37906-18d8-43a3-af2e-ced170496cd4', 'manzana verde', 'rüner Apfel', 1.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('3f9cfc7d-05b7-40e1-9f92-cb3519ad0f7c', '93b37906-18d8-43a3-af2e-ced170496cd4', 'mantequilla de maní', 'Erdnussbutter', 1.0, 'cda', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('28c29eb3-96a0-49df-9e59-4623c39dc96b', '93b37906-18d8-43a3-af2e-ced170496cd4', 'arándanos', 'Blaubeeren', 50.0, 'g', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('c36cc309-537c-4769-a16f-de53c0d0898a', 'edb3c1a4-1c87-4da5-b43d-9a129ee26d68', 'leche (3,5% de grasa)', 'Milch (3,5% Fett)', 100.0, 'ml', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('60ce2380-aaf8-41a1-a03c-cdc2325bd779', 'edb3c1a4-1c87-4da5-b43d-9a129ee26d68', 'semillas de chía', 'Chia Samen', 1.0, 'cda', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('5ee57c91-2f70-4f7e-a7bf-6ffdd975d310', 'edb3c1a4-1c87-4da5-b43d-9a129ee26d68', 'arándanos', 'Blaubeeren', 80.0, 'g', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('d6e4454d-9cfb-49e9-aff3-3567bb397db1', 'edb3c1a4-1c87-4da5-b43d-9a129ee26d68', 'zumo de limón', 'Zitronensaft', 1.0, 'cdta', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('d833000d-637a-49f5-8b29-23e40a70ba14', 'edb3c1a4-1c87-4da5-b43d-9a129ee26d68', 'coco rallado', 'Kokosraspeln', 1.0, 'cda', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('943334db-fe88-4124-803c-1d610bb3886d', '04eb3c6d-52a6-4000-98dd-5ed70307ef88', 'leche (1,5% de grasa)', 'Milch (1,5% Fett)', 100.0, 'ml', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('eeda7225-2b69-4e39-b74d-75f0e970e857', '04eb3c6d-52a6-4000-98dd-5ed70307ef88', 'semillas de chía', 'Chia Samen', 1.5, 'cda', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('cb01b5f2-365d-4f0e-9f00-56a127b4864c', '04eb3c6d-52a6-4000-98dd-5ed70307ef88', 'cacao en polvo', 'Backkakao', 1.0, 'cdta', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('ee7d4fac-e028-4ce8-8305-12c90059b953', '04eb3c6d-52a6-4000-98dd-5ed70307ef88', 'almendras laminadas', 'Mandelblättchen', 1.0, 'cdta', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('ed5e815c-fb1c-449b-bed4-96b995726dc0', '04eb3c6d-52a6-4000-98dd-5ed70307ef88', 'edulcorante (líquido)', 'Süßstoff (flüssig)', 1.0, 'cdta', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('5d811c18-cc51-41cf-86ef-a0a5d9669d86', '04eb3c6d-52a6-4000-98dd-5ed70307ef88', 'sal', 'Salz', 1.0, 'pizca', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('21d6fd8c-59cd-4df6-be4f-b493d7ebdc5e', '485c5a04-5a4d-4047-b947-7b077c24c84a', 'pepino', 'urke', 0.5, 'G', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('4c241e42-1d95-492c-bcd8-92ceb8621ea8', '485c5a04-5a4d-4047-b947-7b077c24c84a', 'queso crema (bajo en grasa)', 'Frischkäse (fettarm)', 50.0, 'g', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('eda8c04d-eabe-4049-8b9a-ff985761e29f', '485c5a04-5a4d-4047-b947-7b077c24c84a', 'eneldo picado', 'gehackter Dill', 1.0, 'cdta', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('7f23cf48-2a0b-403d-b86a-e04e5b8a3f2d', '485c5a04-5a4d-4047-b947-7b077c24c84a', 'jugo de limón', 'Zitronensaft', 1.0, 'cdta', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('791c0e98-4d9b-4527-9dfe-50e8abc67fda', '485c5a04-5a4d-4047-b947-7b077c24c84a', 'sal', 'Salz', 0.5, 'cdta', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('fcfb9b88-370d-4061-88cc-9c7c1d992aba', '485c5a04-5a4d-4047-b947-7b077c24c84a', '½ cdta de pimienta', '½ TL Pfeffer', 0, '', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('c05561d2-526b-4630-b5f2-29f50bc0db93', '485c5a04-5a4d-4047-b947-7b077c24c84a', 'queso (Gouda)', 'Käse (Gouda)', 30.0, 'g', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('a57d9ec3-f337-4026-8cff-2f13ab29af30', '485c5a04-5a4d-4047-b947-7b077c24c84a', 'jamón cocido', 'Kochschinken', 40.0, 'g', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('6e7f91cb-515b-4cc0-9259-cd7dd16d0d55', 'e5d144d7-cad0-4ad1-8fc2-2c4f632ec08c', 'yogur (bajo en grasa)', 'Joghurt (fettarm)', 200.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('1f98fa31-0b5c-4bc3-8c73-3cbf5fe006ed', 'e5d144d7-cad0-4ad1-8fc2-2c4f632ec08c', 'imón', 'Zitrone', 0.5, 'l', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('26930862-52ab-40cb-a7ae-40b237c3681f', 'e5d144d7-cad0-4ad1-8fc2-2c4f632ec08c', 'frambuesas', 'Himbeeren', 40.0, 'g', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('b6790bba-2440-4bdc-8fc1-93f39366c3d7', 'e5d144d7-cad0-4ad1-8fc2-2c4f632ec08c', 'arándanos', 'Blaubeeren', 40.0, 'g', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('51a4dd3e-46bf-4d22-a4a8-0622131b28cb', 'e5d144d7-cad0-4ad1-8fc2-2c4f632ec08c', 'fresas', 'Erdbeeren', 50.0, 'g', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('22e6785a-e1ce-4ea6-ae2a-b5564bfac92f', 'e5d144d7-cad0-4ad1-8fc2-2c4f632ec08c', 'edulcorante (líquido)', 'Süßstoff (flüssig)', 1.0, 'cdta', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('78998199-0508-4a0b-b8b7-4bbb4df137cc', '3faf90dc-5b23-443d-83cb-0fcbcb459e31', 'leche (1,5% de grasa)', 'Milch (1,5% Fett)', 150.0, 'ml', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('e436f3d4-299e-4d9e-baf1-9d35400aff33', '3faf90dc-5b23-443d-83cb-0fcbcb459e31', 'semillas de chía', 'Chia Samen', 1.0, 'cda', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('7f58f3b7-2396-46ca-a985-2b458f33e487', '3faf90dc-5b23-443d-83cb-0fcbcb459e31', 'almendras laminadas', 'Mandelblättchen', 1.0, 'cda', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('e38372c5-db43-4d4f-80ff-308512eb9174', '3faf90dc-5b23-443d-83cb-0fcbcb459e31', 'edulcorante (líquido)', 'Süßstoff (flüssig)', 1.0, 'cdta', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('e6b0ec52-f13a-4d3d-8dd0-111f82d17570', '3faf90dc-5b23-443d-83cb-0fcbcb459e31', 'arándanos', 'Blaubeeren', 80.0, 'g', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('50928212-379b-43d9-aa8c-0cd73944b16f', '3faf90dc-5b23-443d-83cb-0fcbcb459e31', 'otas de aroma de vainilla', 'Vanillearoma', 2.0, 'g', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('7006bf62-c3e3-43c9-8bc7-9e832ecc50a6', '7c13b499-591e-4708-a493-dbcb843bde8c', 'Mango', 'Mango', 0.5, '', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('cb34b809-26bb-45f3-812f-7a3a6394158d', '7c13b499-591e-4708-a493-dbcb843bde8c', 'Leche (1,5% grasa)', 'Milch (1,5% Fett)', 30.0, 'ml', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('bbb2ab78-ae6c-4885-b500-89e1ee003b10', '7c13b499-591e-4708-a493-dbcb843bde8c', 'Yogur griego', 'Griechischer Joghurt', 100.0, 'g', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('cd3d97a0-9d88-4234-8113-9aab825f3ff6', '7c13b499-591e-4708-a493-dbcb843bde8c', 'Zumo de lima', 'Limettensaft', 1.0, 'cdta', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('70fdfed3-44aa-482e-b7fe-70022b22ea68', '7c13b499-591e-4708-a493-dbcb843bde8c', 'Edulcorante (líquido)', 'Süßstoff (flüssig)', 1.0, 'cdta', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('fe6f68fc-3693-413c-9d54-b38cfed73555', '2318330a-3a8f-43a6-bd5b-cf28545c42ad', 'Leche (1,5% grasa)', 'Milch (1,5% Fett)', 100.0, 'ml', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('a0d03fad-fcec-4049-a1d9-ed40458433c8', '2318330a-3a8f-43a6-bd5b-cf28545c42ad', 'Yogur (bajo en grasa)', 'Joghurt (fettarm)', 100.0, 'g', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('e3239d58-a330-48a7-a2fc-bb4624e754d1', '2318330a-3a8f-43a6-bd5b-cf28545c42ad', 'Harina de algarroba', 'Johannisbrotkernmehl', 0.5, 'cdta', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('bacbceac-a518-4070-89a3-e4e710bfccf0', '2318330a-3a8f-43a6-bd5b-cf28545c42ad', 'Huevo', 'Ei', 1.0, '', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('432e6ae8-77ed-4b26-a1dc-69ae185cc689', '2318330a-3a8f-43a6-bd5b-cf28545c42ad', 'Edulcorante (líquido)', 'Süßstoff (flüssig)', 1.0, 'cdta', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('7edaf97c-64d7-489d-8b5a-c8ecf753f049', '2318330a-3a8f-43a6-bd5b-cf28545c42ad', 'Arándanos', 'Heidelbeeren', 60.0, 'g', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('b1566c09-1cf7-421d-8592-081ca67188cf', '2318330a-3a8f-43a6-bd5b-cf28545c42ad', 'Zumo de limón', 'Zitronensaft', 1.0, 'cdta', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('8552b0e8-7bb6-4e1e-8769-0308dce7fbbd', '2318330a-3a8f-43a6-bd5b-cf28545c42ad', 'sal', 'Salz', 1.0, 'pizca', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('56220dcf-214c-4191-af67-703ca93a5274', '398b8848-7d84-4d35-bccc-61a800464b4b', 'quark desnatado', 'Magerquark', 250.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('05695dee-e6c4-4a8d-ab14-d9d0c3ac2e35', '398b8848-7d84-4d35-bccc-61a800464b4b', 'frambuesas (congeladas)', 'Himbeeren (TK)', 100.0, 'g', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('55d0e32f-d36b-46c4-aa58-16a15d5f0104', '398b8848-7d84-4d35-bccc-61a800464b4b', 'edulcorante (líquido)', 'Süßstoff (flüssig)', 1.0, 'cda.', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('fcfb383d-534a-4fab-a678-b40769f758c2', '398b8848-7d84-4d35-bccc-61a800464b4b', 'agua con gas', 'Wasser (mit Kohlensäure)', 2.0, 'cdas.', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('8df2591e-4864-45e6-92b4-7dce5a15b8cd', 'bc38f094-b7d9-4e31-9ad6-158ffa9d9a29', 'proteína en polvo (chocolate)', 'Proteinpulver (Schoko)', 30.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('a30e3676-4a32-419d-b7df-43b915693be2', 'bc38f094-b7d9-4e31-9ad6-158ffa9d9a29', 'cacao en polvo', 'Backkakao', 1.0, 'cdta.', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('046ac322-0877-46e3-ba38-4130e792bc42', 'bc38f094-b7d9-4e31-9ad6-158ffa9d9a29', 'xilitol (Xucker)', 'Xylit (Xucker)', 1.0, 'cdta.', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('51956385-e949-4619-9a11-16fc98eac537', 'bc38f094-b7d9-4e31-9ad6-158ffa9d9a29', 'huevo', 'Ei', 1.0, '', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('dad37d63-7f62-4b70-99b5-00fca748d21a', 'bc38f094-b7d9-4e31-9ad6-158ffa9d9a29', 'levadura en polvo', 'Backpulver', 0.5, 'cdta.', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('57db5399-54f0-4833-bf1d-4af6b1911a88', 'bc38f094-b7d9-4e31-9ad6-158ffa9d9a29', 'leche (1,5% de grasa)', 'Milch (1,5% Fett)', 50.0, 'ml', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('122df4a3-644e-4d5b-aaaa-cbb2e27ed6f6', '2e11b80d-e814-4032-981b-cbe49aaeaecf', 'harina de almendras', 'Mandelmehl', 1.0, 'cda.', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('32c9e118-a426-428b-b181-e1da5f36cf8d', '2e11b80d-e814-4032-981b-cbe49aaeaecf', 'cacao en polvo', 'Backkakao', 1.0, 'cda.', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('262b44ad-3e53-471f-9886-f7c27df52830', '2e11b80d-e814-4032-981b-cbe49aaeaecf', 'proteína en polvo (chocolate)', 'Proteinpulver (Schoko)', 2.0, 'cdas.', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('2d251bc8-0a03-4c03-8a05-37ae3ede7cb3', '2e11b80d-e814-4032-981b-cbe49aaeaecf', 'leche (1,5% de grasa)', 'Milch (1,5% Fett)', 2.0, 'cdas.', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('24c912e1-473c-43d9-9fa9-cc92386af773', '2e11b80d-e814-4032-981b-cbe49aaeaecf', 'huevo', 'Ei', 1.0, '', 5);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('baa0cf9d-3cf0-434d-b9ce-d277989d5c5e', '2e11b80d-e814-4032-981b-cbe49aaeaecf', 'aceite de coco', 'Kokosöl', 0.5, 'cdta.', 6);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('8b384f29-25c2-4903-a5b0-bcc1b8c4e03b', '2e11b80d-e814-4032-981b-cbe49aaeaecf', 'levadura en polvo', 'Backpulver', 0.5, 'cdta.', 7);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('0eb3216a-c11d-4d97-9cc3-9346afe0d2a8', '2e11b80d-e814-4032-981b-cbe49aaeaecf', 'edulcorante (líquido)', 'Süßstoff (flüssig)', 1.0, 'cdta.', 8);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('f423ab4d-46ef-48b7-8d0f-ba5173552e87', '2e11b80d-e814-4032-981b-cbe49aaeaecf', 'sal', 'Salz', 1.0, 'pizca', 9);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('428dbef9-8d67-4389-b98c-60176f315aa4', '2e11b80d-e814-4032-981b-cbe49aaeaecf', 'Xilitol en polvo', 'Puder-Xylit', 0, '', 10);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('a9dca499-da8b-467a-b232-221ca067760d', '06c0f13a-1d2e-4fee-84d3-4aec214aa10f', 'quark desnatado', 'Magerquark', 250.0, 'g', 1);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('1378351c-d447-4ba7-aae7-f9c6a3dfdfdb', '06c0f13a-1d2e-4fee-84d3-4aec214aa10f', 'frambuesas (congeladas)', 'Himbeeren (TK)', 50.0, 'g', 2);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('03130627-14f1-48e6-9f33-48daec214bdf', '06c0f13a-1d2e-4fee-84d3-4aec214aa10f', 'arándanos (congelados)', 'Heidelbeeren (TK)', 50.0, 'g', 3);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('c652860e-df7e-43f5-8d6d-6c4441afba9e', '06c0f13a-1d2e-4fee-84d3-4aec214aa10f', 'edulcorante (líquido)', 'Süßstoff (flüssig)', 0.5, 'cdta.', 4);
INSERT INTO recipe_ingredients (id, recipe_id, name_es, name_de, quantity, unit, sort_order) VALUES ('68a6c600-3e94-4a5d-8f47-6eb22f441e88', '06c0f13a-1d2e-4fee-84d3-4aec214aa10f', 'agua con gas', 'Wasser (mit Kohlensäure)', 2.0, 'cdas.', 5);