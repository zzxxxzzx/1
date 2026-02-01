(async () => {
    try {
        if (!window.ethereum) {
            throw new Error('❌ MetaMask 未检测！刷新 + 安装扩展。');
        }
        console.log('✅ MetaMask 就位，开始刷...');

        const addr = "0x76bB63b3B46A43BAdbE34DA3dc49e52d0CB43671";  // 你的地址
        const abi = ["function gm() external"];
        
        // 修复：用 v5 兼容的 Web3Provider（Remix 默认 ethers v5）
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        
        // 连接授权（try-catch 防已连卡住）
        try {
            await provider.send("eth_requestAccounts", []);
        } catch (connectErr) {
            console.log('⚠️ 连接已存在，跳过:', connectErr.message);
        }
        const signer = await provider.getSigner();
        const myAddr = await signer.getAddress();
        console.log('✅ 签名者就位:', myAddr);

        const c = new ethers.Contract(addr, abi, signer);
        
        // 测试 1 次
        console.log('🧪 测试 1 次 gm...');
        const testTx = await c.gm({gasLimit: 100000});
        console.log('✅ 测试成功:', testTx.hash);
        await testTx.wait(1);
        
        const times = 5;  // 测试 5 次，成功后改 20/50/100/...
        console.log(`🚀 开始刷 ${times} 次...`);

        for (let i = 1; i <= times; i++) {
            const tx = await c.gm({gasLimit: 100000});
            console.log(`第 ${i} 次 ✅ ${tx.hash}`);
            await tx.wait(1);
            if (i % 5 === 0) await new Promise(r => setTimeout(r, 500));  // 小歇
        }
        console.log("测试完成！改 times=1000 重跑全刷。"); 
    } catch (e) {
        console.error('💥 错误:', e.message);
        console.log('修复: 刷新 Remix + 重连 MetaMask。');
    }
})();