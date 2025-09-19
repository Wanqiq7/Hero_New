#!/bin/bash

# ==============================================================================
# Git 仓库自动化更新与标签上传脚本
# 脚本作者：AI
# 版本：1.0.0
# 功能：
# 1. 自动拉取远程仓库最新代码
# 2. 自动暂存所有修改，并提示用户输入提交信息
# 3. 推送本地提交到远程仓库
# 4. 引导用户创建并推送新的Git标签
# ==============================================================================

echo "🚀 开始更新 GitHub 仓库..."

# 1. 检查当前目录是否为 Git 仓库
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "❌ 错误：当前目录不是一个 Git 仓库。请在仓库根目录执行此脚本。"
    exit 1
fi

# 2. 拉取最新代码
echo "➡️ 拉取远程仓库最新代码..."
if ! git pull; then
    echo "❌ 错误：拉取最新代码失败。可能存在合并冲突，请手动解决后重试。"
    exit 1
fi
echo "✅ 代码已成功同步到最新。"

# 3. 暂存并提交修改
echo "➡️ 暂存所有文件变更..."
git add .

read -p "请输入提交信息（例如: 'feat: add new feature'）： " commit_message

if [[ -z "$commit_message" ]]; then
    echo "❌ 错误：提交信息不能为空。"
    exit 1
fi

git commit -m "$commit_message"
echo "✅ 提交成功。"

# 4. 推送提交
echo "➡️ 推送提交到远程仓库..."
if ! git push; then
    echo "❌ 错误：推送失败。可能存在网络问题或远程仓库已更新，请再次运行脚本。"
    exit 1
fi
echo "✅ 代码已成功推送。"

# 5. 创建并推送新标签
echo ""
echo "----------------------------------------"
echo "🏷️ 开始处理 Git 标签..."
read -p "请输入新的版本标签（例如: 'v1.0.0' 或 'v1.1.0'）： " tag_name

if [[ -z "$tag_name" ]]; then
    echo "✅ 跳过标签创建，脚本执行完毕。"
    exit 0
fi

if git rev-parse "$tag_name" > /dev/null 2>&1; then
    echo "⚠️ 警告：标签 '$tag_name' 已存在。请使用一个新标签名。"
else
    # 创建本地标签
    git tag -a "$tag_name" -m "Release $tag_name"
    echo "✅ 本地标签 '$tag_name' 已创建。"

    # 推送标签到远程仓库
    git push origin "$tag_name"
    echo "✅ 标签 '$tag_name' 已推送到远程仓库。"
fi

echo "🎉 脚本执行完毕。仓库已更新并上传标签。"