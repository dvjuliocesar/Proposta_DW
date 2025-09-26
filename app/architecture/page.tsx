import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { Database, ArrowRight, Layers, Zap } from "lucide-react"

export default function ArchitecturePage() {
  return (
    <div className="min-h-screen bg-background">
      <div className="container mx-auto px-4 py-8">
        <div className="mb-8">
          <h1 className="text-3xl font-bold text-foreground mb-4">Arquitetura do Data Warehouse</h1>
          <p className="text-lg text-muted-foreground">Estrutura em 3 camadas com modelagem dimensional Star Schema</p>
        </div>

        {/* Architecture Flow */}
        <Card className="mb-8">
          <CardHeader>
            <CardTitle>Fluxo de Dados</CardTitle>
            <CardDescription>Processo completo desde a ingestão até a análise</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="flex items-center justify-between p-6 bg-muted rounded-lg">
              <div className="text-center">
                <Database className="h-12 w-12 mx-auto mb-2 text-blue-500" />
                <h3 className="font-semibold">API Amazon</h3>
                <p className="text-sm text-muted-foreground">Dados de Produtos</p>
              </div>
              <ArrowRight className="h-6 w-6 text-muted-foreground" />
              <div className="text-center">
                <Layers className="h-12 w-12 mx-auto mb-2 text-green-500" />
                <h3 className="font-semibold">Staging Layer</h3>
                <p className="text-sm text-muted-foreground">Dados Brutos</p>
              </div>
              <ArrowRight className="h-6 w-6 text-muted-foreground" />
              <div className="text-center">
                <Zap className="h-12 w-12 mx-auto mb-2 text-purple-500" />
                <h3 className="font-semibold">Core Layer</h3>
                <p className="text-sm text-muted-foreground">Star Schema</p>
              </div>
              <ArrowRight className="h-6 w-6 text-muted-foreground" />
              <div className="text-center">
                <Database className="h-12 w-12 mx-auto mb-2 text-orange-500" />
                <h3 className="font-semibold">Analytics Layer</h3>
                <p className="text-sm text-muted-foreground">Views & KPIs</p>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Layers Detail */}
        <div className="grid lg:grid-cols-3 gap-6 mb-8">
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Layers className="h-5 w-5 text-green-500" />
                Staging Layer
              </CardTitle>
              <CardDescription>Camada de ingestão de dados brutos</CardDescription>
            </CardHeader>
            <CardContent>
              <div className="space-y-3">
                <div>
                  <h4 className="font-semibold">Tabelas:</h4>
                  <ul className="text-sm text-muted-foreground space-y-1">
                    <li>• STG_PRODUCTS</li>
                    <li>• STG_CUSTOMERS</li>
                    <li>• STG_ORDERS</li>
                    <li>• STG_REVIEWS</li>
                  </ul>
                </div>
                <div>
                  <Badge variant="outline">Schema: STAGING</Badge>
                </div>
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Zap className="h-5 w-5 text-purple-500" />
                Core Layer
              </CardTitle>
              <CardDescription>Modelagem dimensional Star Schema</CardDescription>
            </CardHeader>
            <CardContent>
              <div className="space-y-3">
                <div>
                  <h4 className="font-semibold">Tabelas:</h4>
                  <ul className="text-sm text-muted-foreground space-y-1">
                    <li>• FACT_SALES (Fato)</li>
                    <li>• DIM_PRODUCT</li>
                    <li>• DIM_CUSTOMER</li>
                    <li>• DIM_TIME</li>
                    <li>• DIM_LOCATION</li>
                  </ul>
                </div>
                <div>
                  <Badge variant="outline">Schema: CORE</Badge>
                </div>
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Database className="h-5 w-5 text-orange-500" />
                Analytics Layer
              </CardTitle>
              <CardDescription>Views e agregações para análise</CardDescription>
            </CardHeader>
            <CardContent>
              <div className="space-y-3">
                <div>
                  <h4 className="font-semibold">Views:</h4>
                  <ul className="text-sm text-muted-foreground space-y-1">
                    <li>• SALES_SUMMARY</li>
                    <li>• PRODUCT_PERFORMANCE</li>
                    <li>• CUSTOMER_SEGMENTS</li>
                    <li>• MONTHLY_TRENDS</li>
                  </ul>
                </div>
                <div>
                  <Badge variant="outline">Schema: ANALYTICS</Badge>
                </div>
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Star Schema Detail */}
        <Card>
          <CardHeader>
            <CardTitle>Modelagem Star Schema</CardTitle>
            <CardDescription>Estrutura dimensional otimizada para análises</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="grid md:grid-cols-2 gap-6">
              <div>
                <h3 className="font-semibold mb-3">Tabela Fato</h3>
                <Card className="bg-blue-50 border-blue-200">
                  <CardHeader className="pb-3">
                    <CardTitle className="text-lg">FACT_SALES</CardTitle>
                  </CardHeader>
                  <CardContent>
                    <ul className="text-sm space-y-1">
                      <li>
                        <strong>Chaves:</strong>
                      </li>
                      <li>• product_key (FK)</li>
                      <li>• customer_key (FK)</li>
                      <li>• time_key (FK)</li>
                      <li>• location_key (FK)</li>
                      <li>
                        <strong>Métricas:</strong>
                      </li>
                      <li>• quantity</li>
                      <li>• unit_price</li>
                      <li>• total_amount</li>
                    </ul>
                  </CardContent>
                </Card>
              </div>

              <div>
                <h3 className="font-semibold mb-3">Tabelas Dimensão</h3>
                <div className="space-y-3">
                  <Card className="bg-green-50 border-green-200">
                    <CardHeader className="pb-2">
                      <CardTitle className="text-sm">DIM_PRODUCT</CardTitle>
                    </CardHeader>
                    <CardContent className="pt-0">
                      <p className="text-xs text-muted-foreground">
                        Informações dos produtos: nome, categoria, marca, preço
                      </p>
                    </CardContent>
                  </Card>

                  <Card className="bg-purple-50 border-purple-200">
                    <CardHeader className="pb-2">
                      <CardTitle className="text-sm">DIM_CUSTOMER</CardTitle>
                    </CardHeader>
                    <CardContent className="pt-0">
                      <p className="text-xs text-muted-foreground">Dados dos clientes: nome, segmento, histórico</p>
                    </CardContent>
                  </Card>

                  <Card className="bg-orange-50 border-orange-200">
                    <CardHeader className="pb-2">
                      <CardTitle className="text-sm">DIM_TIME</CardTitle>
                    </CardHeader>
                    <CardContent className="pt-0">
                      <p className="text-xs text-muted-foreground">Hierarquia temporal: ano, trimestre, mês, dia</p>
                    </CardContent>
                  </Card>

                  <Card className="bg-pink-50 border-pink-200">
                    <CardHeader className="pb-2">
                      <CardTitle className="text-sm">DIM_LOCATION</CardTitle>
                    </CardHeader>
                    <CardContent className="pt-0">
                      <p className="text-xs text-muted-foreground">Localização: país, estado, cidade, região</p>
                    </CardContent>
                  </Card>
                </div>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  )
}
