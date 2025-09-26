import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { BarChart3, TrendingUp, Users, ShoppingCart, DollarSign, Calendar } from "lucide-react"

const analyticsQueries = [
  {
    title: "Vendas por Período",
    description: "Análise temporal das vendas com comparação mensal e anual",
    icon: Calendar,
    metrics: ["Receita Total", "Quantidade Vendida", "Ticket Médio"],
    query: `SELECT 
  DATE_TRUNC('month', order_date) as mes,
  SUM(total_amount) as receita_total,
  COUNT(*) as total_pedidos,
  AVG(total_amount) as ticket_medio
FROM ANALYTICS.SALES_SUMMARY 
GROUP BY mes 
ORDER BY mes DESC;`,
  },
  {
    title: "Performance de Produtos",
    description: "Ranking dos produtos mais vendidos e rentáveis",
    icon: ShoppingCart,
    metrics: ["Top Produtos", "Margem de Lucro", "Giro de Estoque"],
    query: `SELECT 
  p.product_name,
  SUM(f.quantity) as total_vendido,
  SUM(f.total_amount) as receita_total,
  AVG(f.unit_price) as preco_medio
FROM CORE.FACT_SALES f
JOIN CORE.DIM_PRODUCT p ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY receita_total DESC
LIMIT 10;`,
  },
  {
    title: "Análise de Clientes",
    description: "Segmentação e comportamento de compra dos clientes",
    icon: Users,
    metrics: ["CLV", "Frequência de Compra", "Segmentação RFM"],
    query: `SELECT 
  customer_segment,
  COUNT(*) as total_clientes,
  AVG(total_spent) as gasto_medio,
  AVG(order_frequency) as freq_compra_media
FROM ANALYTICS.CUSTOMER_SEGMENTS
GROUP BY customer_segment
ORDER BY gasto_medio DESC;`,
  },
  {
    title: "Análise Geográfica",
    description: "Performance de vendas por região e localização",
    icon: TrendingUp,
    metrics: ["Vendas por Estado", "Concentração Regional", "Oportunidades"],
    query: `SELECT 
  l.state,
  l.city,
  COUNT(*) as total_pedidos,
  SUM(f.total_amount) as receita_total
FROM CORE.FACT_SALES f
JOIN CORE.DIM_LOCATION l ON f.location_key = l.location_key
GROUP BY l.state, l.city
ORDER BY receita_total DESC;`,
  },
  {
    title: "Análise Temporal Avançada",
    description: "Sazonalidade, tendências e padrões temporais",
    icon: BarChart3,
    metrics: ["Sazonalidade", "Crescimento", "Previsões"],
    query: `SELECT 
  EXTRACT(YEAR FROM order_date) as ano,
  EXTRACT(QUARTER FROM order_date) as trimestre,
  SUM(total_amount) as receita,
  LAG(SUM(total_amount)) OVER (ORDER BY ano, trimestre) as receita_anterior
FROM CORE.FACT_SALES
GROUP BY ano, trimestre
ORDER BY ano, trimestre;`,
  },
  {
    title: "KPIs Financeiros",
    description: "Indicadores financeiros e métricas de performance",
    icon: DollarSign,
    metrics: ["ROI", "Margem Bruta", "EBITDA"],
    query: `SELECT 
  'Receita Total' as metrica,
  SUM(total_amount) as valor
FROM CORE.FACT_SALES
UNION ALL
SELECT 
  'Ticket Médio' as metrica,
  AVG(total_amount) as valor
FROM CORE.FACT_SALES;`,
  },
]

export default function AnalyticsPage() {
  return (
    <div className="min-h-screen bg-background">
      <div className="container mx-auto px-4 py-8">
        <div className="mb-8">
          <h1 className="text-3xl font-bold text-foreground mb-4">Análises e KPIs</h1>
          <p className="text-lg text-muted-foreground">
            Consultas analíticas para extrair insights de negócio do Data Warehouse
          </p>
        </div>

        <div className="grid lg:grid-cols-2 gap-6">
          {analyticsQueries.map((analysis, index) => {
            const IconComponent = analysis.icon
            return (
              <Card key={index} className="h-fit">
                <CardHeader>
                  <CardTitle className="flex items-center gap-3">
                    <IconComponent className="h-6 w-6 text-primary" />
                    {analysis.title}
                  </CardTitle>
                  <CardDescription>{analysis.description}</CardDescription>
                </CardHeader>
                <CardContent className="space-y-4">
                  <div>
                    <h4 className="font-semibold mb-2">Métricas Principais:</h4>
                    <div className="flex flex-wrap gap-2">
                      {analysis.metrics.map((metric, idx) => (
                        <Badge key={idx} variant="secondary">
                          {metric}
                        </Badge>
                      ))}
                    </div>
                  </div>

                  <div>
                    <h4 className="font-semibold mb-2">Consulta SQL:</h4>
                    <div className="bg-muted p-3 rounded-md">
                      <pre className="text-sm text-muted-foreground overflow-x-auto">
                        <code>{analysis.query}</code>
                      </pre>
                    </div>
                  </div>
                </CardContent>
              </Card>
            )
          })}
        </div>

        <Card className="mt-8">
          <CardHeader>
            <CardTitle>Dashboard Recomendado</CardTitle>
            <CardDescription>Estrutura sugerida para dashboard executivo</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-4">
              <div className="text-center p-4 border rounded-lg">
                <DollarSign className="h-8 w-8 mx-auto mb-2 text-green-500" />
                <h3 className="font-semibold">Receita</h3>
                <p className="text-2xl font-bold">R$ 2.5M</p>
                <p className="text-sm text-green-600">+15% vs mês anterior</p>
              </div>
              <div className="text-center p-4 border rounded-lg">
                <ShoppingCart className="h-8 w-8 mx-auto mb-2 text-blue-500" />
                <h3 className="font-semibold">Pedidos</h3>
                <p className="text-2xl font-bold">12.5K</p>
                <p className="text-sm text-blue-600">+8% vs mês anterior</p>
              </div>
              <div className="text-center p-4 border rounded-lg">
                <Users className="h-8 w-8 mx-auto mb-2 text-purple-500" />
                <h3 className="font-semibold">Clientes</h3>
                <p className="text-2xl font-bold">8.2K</p>
                <p className="text-sm text-purple-600">+12% vs mês anterior</p>
              </div>
              <div className="text-center p-4 border rounded-lg">
                <TrendingUp className="h-8 w-8 mx-auto mb-2 text-orange-500" />
                <h3 className="font-semibold">Ticket Médio</h3>
                <p className="text-2xl font-bold">R$ 200</p>
                <p className="text-sm text-orange-600">+5% vs mês anterior</p>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  )
}
