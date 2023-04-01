<script lang="ts" setup>
import { computed, onMounted, ref } from 'vue'
import { NButton, NInput, NSpin, useMessage } from 'naive-ui'
import { useSettingStore, useAuthStore } from '@/store'
import type { SettingsState } from '@/store/modules/settings/helper'
import { t } from '@/locales'
import { fetchChatConfig } from '@/api'
import pkg from '@/../package.json'

interface ConfigState {
  apiModel?: string
  balance?: string
}
 
const settingStore = useSettingStore()
const authStore = useAuthStore()
const loading = ref(false)
const config = ref<ConfigState>()
const isChatGPTAPI = computed<boolean>(() => !!authStore.isChatGPTAPI)

const ms = useMessage()

const systemMessage = ref(settingStore.systemMessage ?? '')

function updateSettings(options: Partial<SettingsState>) {
  settingStore.updateSetting(options)
  ms.success(t('common.success'))
}

function handleReset() {
  settingStore.resetSetting()
  ms.success(t('common.success'))
  window.location.reload()
}
async function fetchConfig() {
  try {
    loading.value = true
    const { data } = await fetchChatConfig<ConfigState>()
    config.value = data
  }
  finally {
    loading.value = false
  }
}
onMounted(() => {
  fetchConfig()
})
</script>

<template>
  <NSpin :show="loading">
    <div class="p-4 space-y-4">
      <h2 class="text-xl font-bold">
        Version - {{ pkg.version }}
      </h2>
      <div class="p-2 space-y-2 rounded-md bg-neutral-100 dark:bg-neutral-700">
        <p>
          Powered by:
          <a
            class="text-blue-600 dark:text-blue-500"
            href="https://github.com/pzcn"
            target="_blank"
          >
            PedroZ
          </a>
        </p>
        <p>
          Source code:
          <a
            class="text-blue-600 dark:text-blue-500"
            href="https://github.com/Chanzhaoyu/chatgpt-web"
            target="_blank"
          >
            Github
          </a>
        </p>
      </div>
    <div class="flex items-center space-x-4">
      <p v-if="isChatGPTAPI">
        {{ $t("setting.balance") }}：{{ config?.balance ?? '-' }}
      </p>
      </div>
      <div class="flex items-center space-x-4">
      <p>{{ $t("setting.apiModel") }}：{{ config?.apiModel ?? '-' }}</p>
      </div>
      <div class="flex items-center space-x-4">
        <span class="flex-shrink-0">{{ $t('setting.role') }}</span>
        <div class="flex-1">
          <NInput v-model:value="systemMessage" type="textarea" :autosize="{ minRows: 1, maxRows: 4 }" />
        </div>
        <NButton size="tiny" text type="primary" @click="updateSettings({ systemMessage })">
          {{ $t('common.save') }}
        </NButton>
      </div>
      <div class="flex items-center space-x-4">
        <span class="flex-shrink-0">&nbsp;</span>
        <NButton size="small" @click="handleReset">
          {{ $t('common.reset') }}
        </NButton>
      </div>
    </div>
  </NSpin>
</template>
