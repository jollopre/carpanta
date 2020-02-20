tasks = lambda do
  [
    { name: 'Corte Caballero con lavado', price: 1000 },
    { name: 'Arreglo de barba', price: 500 },
    { name: 'Arreglo flequillo', price: 300 },
    { name: 'Corte nin@', price: 500 },
    { name: 'Lavar y secar', price: 1200 },
    { name: 'Retoque "mentira", lavar y secar', price: 1800 },
    { name: 'Corte y secado "al aire"', price: 1500 },
    { name: 'Corte y secado', price: 2500 },
    { name: 'Color y secado', price: 3500 },
    { name: 'Color, secado y corte', price: 4000 },
    { name: 'Mechas para iluminar en frontal', price: 1500 },
    { name: 'Mechas pelo corto "al aire"', price: 2500 },
    { name: 'Mechas pelo corto y secado', price: 3000 },
    { name: 'Mechas pelo corto, corte y secado', price: 3500 },
    { name: 'Mechas y secado', price: 4000 },
    { name: 'Mechas, secado y corte', price: 5000 },
    { name: 'Degradado y secado', price: 4500 },
    { name: 'Degradado con retoque raiz y secado', price: 6000 },
    { name: 'Degradado con retoque de raiz, corte y secado', price: 6500 },
    { name: 'Matiz', price: 1500 },
    { name: 'Deco arrastre', description: 'hasta 3 decoloraciones', price: 9000 },
    { name: 'Color global', description: 'hasta 2 tubos', price: 5000 },
    { name: 'Alisado ORGANIC', description: 'Por gramo', price: 150 },
    { name: 'Permanente', price: 3500 },
    { name: 'Peinado de fallera', price: 3000 },
    { name: 'Peinado de fallera cosido', price: 2500 },
    { name: 'Recogido fiesta', price: 3000 },
    { name: 'Tratamiento ELUMEN', description: '0.60 por gramo', price: 3000 },
    { name: 'Tratamiento REPARADOR y secado', price: 3500 }
  ]
end

customers = lambda do
  [
    { name: 'Ben', surname: 'Dover', email: 'ben.dover@carpanta.com', phone: '600111222' }
  ]
end

lambda do
  __ = Carpanta::Services
  tasks.call.each { |task| __::Tasks.create!(task) }
  customers.call.each { |customer| __::Customers.create!(customer) }
end.call