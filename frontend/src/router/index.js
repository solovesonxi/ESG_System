import {createRouter, createWebHistory} from 'vue-router'
import MaterialView from '@/views/MaterialView.vue'
import EnergyView from "@/views/EnergyView.vue";
import WaterView from "@/views/WaterView.vue";
import EmissionView from "@/views/EmissionView.vue";
import WasteView from "@/views/WasteView.vue";
import InvestmentView from "@/views/InvestmentView.vue";
import EmploymentView from "@/views/EmploymentView.vue";
import TrainingView from "@/views/TrainingView.vue";
import OHSView from "@/views/OHSView.vue";
import SatisfactionView from "@/views/SatisfactionView.vue";
import SupplyView from "@/views/SupplyView.vue";
import IPView from "@/views/IPView.vue";
import ResponsibilityView from "@/views/ResponsibilityView.vue";
import CommunityView from "@/views/CommunityView.vue";
import EnvQuantitativeView from "@/views/EnvQuantitativeView.vue";
import EnvQualitativeView from "@/views/EnvQualitativeView.vue";
import SocialQuantitativeLaborView from "@/views/SocialQuantitativeLaborView.vue";
import SocialQualitativeLaborView from "@/views/SocialQualitativeLaborView.vue";
import SocialQuantitativeOtherView from "@/views/SocialQuantitativeOtherView.vue";
import SocialQualitativeOtherView from "@/views/SocialQualitativeOtherView.vue";
import GovernanceView from "@/views/GovernanceView.vue";

const routes = [
    {path: '/', redirect: '/material'},
    {path: '/material', component: MaterialView},
    {path: '/energy', component: EnergyView},
    {path: '/water', component: WaterView},
    {path: '/emission', component: EmissionView},
    {path: '/waste', component: WasteView},
    {path: '/investment', component: InvestmentView},
    {path: '/employment', component: EmploymentView},
    {path: '/training', component: TrainingView},
    {path: '/ohs', component: OHSView},
    {path: '/satisfaction', component: SatisfactionView},
    {path: '/supply', component: SupplyView},
    {path: '/ip', component: IPView},
    {path: '/responsibility', component: ResponsibilityView},
    {path: '/community', component: CommunityView},
    {path: '/env-quantitative', component: EnvQuantitativeView},
    {path: '/env-qualitative', component: EnvQualitativeView},
    {path: '/social-quantitative-labor', component: SocialQuantitativeLaborView},
    {path: '/social-qualitative-labor', component: SocialQualitativeLaborView},
    {path: '/social-quantitative-other', component: SocialQuantitativeOtherView},
    {path: '/social-qualitative-other', component: SocialQualitativeOtherView},
    {path: '/governance', component: GovernanceView},
]

const router = createRouter({
    history: createWebHistory(import.meta.env.BASE_URL), routes
})

export default router