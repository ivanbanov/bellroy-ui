import express from 'express'
import type { Request, Response } from 'express'
import { faker } from '@faker-js/faker'

const images = [
  'BTWB-NSK-213',
  'EDKC-BSH-228',
  'BPWA-STO-215',
  'BHMB-SDN-243',
  'WCWA-EGD-301',
  'BIVA-BRZ-213',
  'EKCF-BLK-101',
  'BLHA-ASH-234',
  'BVCA-RGN-213',
  'BLPA-BLK-241',
  'BMVA-NSK-218',
  'ETKA-BSH-228',
  'ETWA-RVN-213',
  'BSMA-SLT-230',
  'BVTA-JBK-235',
  'WTFB-BSH-302',
  'EKCE-CAR-101',
  'WNSC-EGD-301',
  'ETKA-SLT-230',
  'BKWA-RVN-213',
  'BPWB-OLI-215',
  'BLPB-BLK-241',
]

const tags = ['basic', 'discount', 'special', 'bestSeller']

interface Product {
  id: string
  name: string
  description: string
  price: number
  imageUrl: string
  styles: string[]
  tags: string[]
}

let i = 0

const generateProduct = (): Product => ({
  id: faker.string.uuid(),
  name: faker.commerce.productName(),
  description: `${faker.commerce.productAdjective()} ${faker.commerce.product()}`,
  price: +faker.commerce.price(),
  imageUrl: `https://bellroy-product-images.imgix.net/bellroy_dot_com_range_page_image/EUR/${images[i > images.length ? (i = 0) : i++]}/0?auto=format&amp;fit=max&amp;w=160`,
  styles: Array.from({ length: 5 }, () => faker.color.rgb()),
  tags: [tags[faker.number.int({ min: 0, max: tags.length - 1 })]],
})

const app = express()
const port = 3000

app.use((_req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*')
  next()
})

app.get('/products', (req: Request, res: Response) => {
  res.json([...Array(10)].map(() => generateProduct()))
})

app.listen(port, () => {
  // eslint-disable-next-line no-console -- server logs
  console.info(`Server is running on http://localhost:${port}`)
})
