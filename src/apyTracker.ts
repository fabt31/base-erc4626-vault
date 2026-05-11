import { ethers } from "ethers";
interface SnapshotEntry { timestamp: number; sharePrice: bigint; }
export class APYTracker {
  private snapshots: SnapshotEntry[] = [];
  recordSnapshot(sharePrice: bigint) {
    this.snapshots.push({ timestamp: Date.now(), sharePrice });
    if (this.snapshots.length > 1000) this.snapshots.shift();
  }
  getAPY(days: 7 | 30): number {
    const now = Date.now();
    const cutoff = now - days * 86400 * 1000;
    const old = this.snapshots.find(s => s.timestamp >= cutoff);
    if (!old || this.snapshots.length < 2) return 0;
    const latest = this.snapshots[this.snapshots.length - 1];
    const growth = Number(latest.sharePrice - old.sharePrice) / Number(old.sharePrice);
    return (growth / days) * 365 * 100;
  }
}