/**
 * 通用JavaScript函数库
 * 用于LuCI应用程序的公共功能
 */

/**
 * 显示通用模态框
 * @param {string} message - 要显示的消息
 * @param {number} duration - 显示时长（毫秒），默认2000ms
 * @param {string} type - 消息类型：'info', 'success', 'warning', 'error'，默认'info'
 */
function showCommonModal(message, duration = 2000, type = 'info') {
    // 移除已存在的模态框
    const existingModal = document.querySelector('.common-modal-mask');
    if (existingModal) {
        existingModal.remove();
    }

    // 创建模态框元素
    const modalMask = document.createElement('div');
    modalMask.className = 'common-modal-mask';
    
    const modalContent = document.createElement('div');
    modalContent.className = 'common-modal-content';
    
    // 统一使用黑色背景，参照work_mode.htm的样式
    modalContent.style.backgroundColor = 'rgba(0, 0, 0, 0.5)';
    modalContent.style.color = 'white';
    
    modalContent.textContent = message;
    
    // 组装模态框
    modalMask.appendChild(modalContent);
    document.body.appendChild(modalMask);
    
    // 显示模态框
    setTimeout(() => {
        modalMask.classList.add('show');
    }, 10);
    
    // 自动隐藏
    setTimeout(() => {
        modalMask.classList.remove('show');
        setTimeout(() => {
            if (modalMask.parentNode) {
                modalMask.remove();
            }
        }, 300);
    }, duration);
}

/**
 * 显示成功消息
 * @param {string} message - 消息内容
 * @param {number} duration - 显示时长
 */
function showSuccess(message, duration = 2000) {
    showCommonModal(message, duration);
}

/**
 * 显示警告消息
 * @param {string} message - 消息内容
 * @param {number} duration - 显示时长
 */
function showWarning(message, duration = 2000) {
    showCommonModal(message, duration);
}

/**
 * 显示错误消息
 * @param {string} message - 消息内容
 * @param {number} duration - 显示时长
 */
function showError(message, duration = 3000) {
    showCommonModal(message, duration);
}

/**
 * 显示信息消息
 * @param {string} message - 消息内容
 * @param {number} duration - 显示时长
 */
function showInfo(message, duration = 2000) {
    showCommonModal(message, duration);
}

/**
 * 确认对话框
 * @param {string} message - 确认消息
 * @param {function} onConfirm - 确认回调函数
 * @param {function} onCancel - 取消回调函数
 * @param {string} confirmText - 确认按钮文本
 * @param {string} cancelText - 取消按钮文本
 */
function showConfirmModal(message, onConfirm, onCancel, confirmText = '确定', cancelText = '取消') {
    // 移除已存在的模态框
    const existingModal = document.querySelector('.common-modal-mask');
    if (existingModal) {
        existingModal.remove();
    }

    // 创建确认模态框
    const modalMask = document.createElement('div');
    modalMask.className = 'common-modal-mask';
    
    const modalContent = document.createElement('div');
    modalContent.className = 'common-modal-content';
    modalContent.style.width = '300px';
    modalContent.style.height = 'auto';
    modalContent.style.minHeight = '120px';
    modalContent.style.padding = '20px';
    modalContent.style.flexDirection = 'column';
    modalContent.style.justifyContent = 'space-between';
    modalContent.style.backgroundColor = 'rgba(0, 0, 0, 0.5)';
    modalContent.style.color = 'white';
    
    // 消息文本
    const messageDiv = document.createElement('div');
    messageDiv.textContent = message;
    messageDiv.style.marginBottom = '20px';
    messageDiv.style.textAlign = 'center';
    
    // 按钮容器
    const buttonContainer = document.createElement('div');
    buttonContainer.style.display = 'flex';
    buttonContainer.style.justifyContent = 'center';
    buttonContainer.style.gap = '10px';
    
    // 确认按钮
    const confirmBtn = document.createElement('button');
    confirmBtn.textContent = confirmText;
    confirmBtn.style.padding = '8px 16px';
    confirmBtn.style.backgroundColor = '#2885e8';
    confirmBtn.style.color = 'white';
    confirmBtn.style.border = 'none';
    confirmBtn.style.borderRadius = '4px';
    confirmBtn.style.cursor = 'pointer';
    confirmBtn.onclick = () => {
        modalMask.remove();
        if (onConfirm) onConfirm();
    };
    
    // 取消按钮
    const cancelBtn = document.createElement('button');
    cancelBtn.textContent = cancelText;
    cancelBtn.style.padding = '8px 16px';
    cancelBtn.style.backgroundColor = '#666';
    cancelBtn.style.color = 'white';
    cancelBtn.style.border = 'none';
    cancelBtn.style.borderRadius = '4px';
    cancelBtn.style.cursor = 'pointer';
    cancelBtn.onclick = () => {
        modalMask.remove();
        if (onCancel) onCancel();
    };
    
    // 组装按钮
    buttonContainer.appendChild(confirmBtn);
    buttonContainer.appendChild(cancelBtn);
    
    // 组装模态框
    modalContent.appendChild(messageDiv);
    modalContent.appendChild(buttonContainer);
    modalMask.appendChild(modalContent);
    document.body.appendChild(modalMask);
    
    // 显示模态框
    setTimeout(() => {
        modalMask.classList.add('show');
    }, 10);
}

/**
 * 格式化文件大小
 * @param {number} bytes - 字节数
 * @returns {string} 格式化后的大小
 */
function formatFileSize(bytes) {
    if (bytes === 0) return '0 B';
    const k = 1024;
    const sizes = ['B', 'KB', 'MB', 'GB', 'TB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
}

/**
 * 防抖函数
 * @param {function} func - 要防抖的函数
 * @param {number} wait - 等待时间
 * @returns {function} 防抖后的函数
 */
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

/**
 * 节流函数
 * @param {function} func - 要节流的函数
 * @param {number} limit - 限制时间
 * @returns {function} 节流后的函数
 */
function throttle(func, limit) {
    let inThrottle;
    return function() {
        const args = arguments;
        const context = this;
        if (!inThrottle) {
            func.apply(context, args);
            inThrottle = true;
            setTimeout(() => inThrottle = false, limit);
        }
    };
}

/**
 * 获取URL参数
 * @param {string} name - 参数名
 * @returns {string|null} 参数值
 */
function getUrlParameter(name) {
    const urlParams = new URLSearchParams(window.location.search);
    return urlParams.get(name);
}

/**
 * 设置URL参数
 * @param {string} name - 参数名
 * @param {string} value - 参数值
 */
function setUrlParameter(name, value) {
    const url = new URL(window.location);
    url.searchParams.set(name, value);
    window.history.replaceState({}, '', url);
}

/**
 * 深拷贝对象
 * @param {object} obj - 要拷贝的对象
 * @returns {object} 拷贝后的对象
 */
function deepClone(obj) {
    if (obj === null || typeof obj !== 'object') return obj;
    if (obj instanceof Date) return new Date(obj.getTime());
    if (obj instanceof Array) return obj.map(item => deepClone(item));
    if (typeof obj === 'object') {
        const clonedObj = {};
        for (const key in obj) {
            if (obj.hasOwnProperty(key)) {
                clonedObj[key] = deepClone(obj[key]);
            }
        }
        return clonedObj;
    }
}

function validateIP(ip) {
    if (!ip || ip.trim() === '') return true; 
    const ipRegex = /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/;
    return ipRegex.test(ip.trim());
}

function validateNetmask(mask) {
    if (!mask || mask.trim() === '') return true; 
    const maskRegex = /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/;
    if (!maskRegex.test(mask.trim())) return false;
    const parts = mask.split('.');
    const binary = parts.map(p => parseInt(p).toString(2).padStart(8, '0')).join('');
    return /^1+0*$/.test(binary);
}

window.showCommonModal = showCommonModal;
window.showSuccess = showSuccess;
window.showWarning = showWarning;
window.showError = showError;
window.showInfo = showInfo;
window.showConfirmModal = showConfirmModal;
window.formatFileSize = formatFileSize;
window.debounce = debounce;
window.throttle = throttle;
window.getUrlParameter = getUrlParameter;
window.setUrlParameter = setUrlParameter;
window.deepClone = deepClone;
window.validateIP = validateIP;
window.validateNetmask = validateNetmask; 