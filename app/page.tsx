import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Database, FileText, BarChart3, Settings, Play, Download } from "lucide-react"
import Link from "next/link"

export default function HomePage() {
  return (
    <div className="min-h-screen bg-background">
      <div className="container mx-auto px-4 py-8">
        {/* Header */}
        <div className="text-center mb-12">
          <h1 className="text-4xl font-bold text-foreground mb-4">Snowflake Data Warehouse</h1>
          <p className="text-xl text-muted-foreground max-w-2xl mx-auto">
            Solução completa de Data Warehouse para E-commerce com modelagem dimensional, pipeline ELT e análises
            avançadas
          </p>
          <div className="flex justify-center gap-2 mt-4">
            <Badge variant="secondary">Snowflake</Badge>
            <Badge variant="secondary">Star Schema</Badge>
            <Badge variant="secondary">ELT Pipeline</Badge>
            <Badge variant="secondary">Analytics</Badge>
          </div>
        </div>

        {/* Main Features Grid */}
        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6 mb-12">
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Database className="h-5 w-5 text-primary" />
                Estrutura do DW
              </CardTitle>
              <CardDescription>Arquitetura em 3 camadas: Staging, Core e Analytics</CardDescription>
            </CardHeader>
            <CardContent>
              <ul className="text-sm text-muted-foreground space-y-1">
                <li>• Camada de Staging para dados brutos</li>
                <li>• Camada Core com modelagem dimensional</li>
                <li>• Camada Analytics para consultas otimizadas</li>
              </ul>
              <Link href="/architecture">
                <Button variant="outline" size="sm" className="mt-4 bg-transparent">
                  Ver Arquitetura
                </Button>
              </Link>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Settings className="h-5 w-5 text-primary" />
                Scripts SQL
              </CardTitle>
              <CardDescription>Scripts completos para setup e manutenção</CardDescription>
            </CardHeader>
            <CardContent>
              <ul className="text-sm text-muted-foreground space-y-1">
                <li>• Setup da estrutura do banco</li>
                <li>• Criação de tabelas e procedures</li>
                <li>• Pipeline ELT automatizado</li>
              </ul>
              <Link href="/scripts">
                <Button variant="outline" size="sm" className="mt-4 bg-transparent">
                  Ver Scripts
                </Button>
              </Link>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <BarChart3 className="h-5 w-5 text-primary" />
                Análises
              </CardTitle>
              <CardDescription>Consultas analíticas e KPIs de negócio</CardDescription>
            </CardHeader>
            <CardContent>
              <ul className="text-sm text-muted-foreground space-y-1">
                <li>• Análise de vendas por período</li>
                <li>• Performance de produtos</li>
                <li>• Segmentação de clientes</li>
              </ul>
              <Link href="/analytics">
                <Button variant="outline" size="sm" className="mt-4 bg-transparent">
                  Ver Análises
                </Button>
              </Link>
            </CardContent>
          </Card>
        </div>

        {/* Quick Actions */}
        <Card className="mb-8">
          <CardHeader>
            <CardTitle>Ações Rápidas</CardTitle>
            <CardDescription>Execute os scripts ou visualize a documentação</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="flex flex-wrap gap-4">
              <Button className="flex items-center gap-2">
                <Play className="h-4 w-4" />
                Executar Setup Completo
              </Button>
              <Button variant="outline" className="flex items-center gap-2 bg-transparent">
                <Download className="h-4 w-4" />
                Download Scripts
              </Button>
              <Link href="/documentation">
                <Button variant="outline" className="flex items-center gap-2 bg-transparent">
                  <FileText className="h-4 w-4" />
                  Documentação
                </Button>
              </Link>
            </div>
          </CardContent>
        </Card>

        {/* Architecture Overview */}
        <Card>
          <CardHeader>
            <CardTitle>Visão Geral da Arquitetura</CardTitle>
            <CardDescription>Fluxo de dados e componentes principais do Data Warehouse</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="grid md:grid-cols-3 gap-4 text-center">
              <div className="p-4 border rounded-lg">
                <Database className="h-8 w-8 mx-auto mb-2 text-blue-500" />
                <h3 className="font-semibold">Staging Layer</h3>
                <p className="text-sm text-muted-foreground">Dados brutos da API Amazon</p>
              </div>
              <div className="p-4 border rounded-lg">
                <Settings className="h-8 w-8 mx-auto mb-2 text-green-500" />
                <h3 className="font-semibold">Core Layer</h3>
                <p className="text-sm text-muted-foreground">Modelagem Star Schema</p>
              </div>
              <div className="p-4 border rounded-lg">
                <BarChart3 className="h-8 w-8 mx-auto mb-2 text-purple-500" />
                <h3 className="font-semibold">Analytics Layer</h3>
                <p className="text-sm text-muted-foreground">Views e consultas otimizadas</p>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  )
}
